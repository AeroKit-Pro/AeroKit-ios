//
//  ChecklistsViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 8.06.23.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol ChecklistsSceneDelegate: AnyObject {
    func showSelectPlaneCompany()
    func showMyGroupChecklist(items: [ChecklistWithItemsModel])
}

protocol ChecklistsViewModelInterface {
    func onViewDidLoad()
    func onViewWillAppear()
    func onTapFindButton()
    func onTapEdit()
    func onSelect(item: ChecklistGroupStorageModel)
    func onDelete(item: ChecklistGroupStorageModel)
}

final class ChecklistsViewModel {
    weak var view: ChecklistsViewInterface!
    weak var output: ChecklistsSceneDelegate?
    private let disposeBag = DisposeBag()

    @UserDataStorage(key: UserDefaultsKey.allCompaniesWithPlanes) private var allCompaniesWithPlanes: [CompanyWithPlanesModel]?

    @UserDataStorage(key: UserDefaultsKey.savedChecklists) private var savedChecklists: [ChecklistGroupStorageModel]?

    private var checklistsItems = [ChecklistGroupStorageModel]()
    private(set) var isEditMode = false

    private let dispatchQueue = DispatchQueue(label: "requestQueue", qos: .background)
    private let semaphore = DispatchSemaphore(value: 0)

}

// MARK: - ChecklistsViewModelInterface
extension ChecklistsViewModel: ChecklistsViewModelInterface {
    func onViewDidLoad() {
        self.view.displayLoader()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.notify(queue: .main) {
            self.view.hideLoader()
        }
        dispatchGroup.enter()
        dispatchQueue.async {
            APIClient().getChecklists().subscribe { [weak self] event in
                switch event {
                case .next(let items):
                    self?.allCompaniesWithPlanes = items
                case .completed:
                    self?.semaphore.signal()
                    dispatchGroup.leave()
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
            self.semaphore.wait()
        }

        dispatchGroup.enter()
        dispatchQueue.async {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            APIClient().getUserChecklistsGroups(userId: userId).subscribe { [weak self] event in
                switch event {
                case .next(let item):
                    let allCompaniesWithPlanes: [CompanyWithPlanesModel] = self?.allCompaniesWithPlanes ?? []
                    let allPlanes = allCompaniesWithPlanes.flatMap { $0.planes }
                    let allChecklistGroups = allPlanes.flatMap { $0.checklists }
                    self?.savedChecklists = item.checklists_groups.compactMap { item in
                        if let checklistGroup = allChecklistGroups.first(where: { $0.id == item.id }),
                           let plane = allPlanes.first(where: { $0.checklists.contains(checklistGroup)}) {
                            let company = allCompaniesWithPlanes.first(where: { $0.planes.contains(plane) })
                            let fullname: String = {
                                var fullname = ""
                                if let companyName = company?.name {
                                    fullname += companyName
                                    fullname += " "
                                }
                                fullname += plane.model
                                return fullname
                            }()

                            return ChecklistGroupStorageModel(
                                id: plane.id,
                                date: Date(),
                                name: item.name,
                                fullPlaneName: fullname,
                                isFullChecklistModel: plane.checklists.count == item.checklists_ids.count,
                                checklists: item.checklists_ids.compactMap { id in return plane.checklists.first(where: { $0.id == id }) })
                        }
                        return nil
                    }
                case .completed:
                    self?.semaphore.signal()
                    dispatchGroup.leave()
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
            self.semaphore.wait()
        }
    }

    func onViewWillAppear() {
        if let savedChecklists = savedChecklists,
           !savedChecklists.isEmpty {
            self.checklistsItems = savedChecklists.sorted(by: { $0.date > $1.date })
            view.updateState(.data(items: checklistsItems))
        } else {
            view.updateState(.empty)
        }
    }

    func onTapFindButton() {
        output?.showSelectPlaneCompany()
    }

    func onTapEdit() {
        isEditMode.toggle()
        view.updateState(isEditMode ? .edit : .data(items: checklistsItems))
    }

    func onSelect(item: ChecklistGroupStorageModel) {
        if !isEditMode {
            output?.showMyGroupChecklist(items: item.checklists)
        }
    }

    func onDelete(item: ChecklistGroupStorageModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        APIClient()
            .deleteUserChecklistsGroups(userId: userId, groupId: String(item.id))
            .subscribe { [weak self] event in
            switch event {
            case .next:
                guard let self = self else { return }
                if let index = checklistsItems.firstIndex(of: item) {
                    self.checklistsItems.remove(at: index)
                    self.savedChecklists = self.checklistsItems
                    self.view.updateState(self.checklistsItems.isEmpty ? .empty : .data(items: self.checklistsItems))
                }
            default:
                break
            }
        }.disposed(by: disposeBag)

    }
}
