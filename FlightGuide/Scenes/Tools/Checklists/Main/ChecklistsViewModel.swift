//
//  ChecklistsViewModel.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 8.06.23.
//

import Foundation

protocol ChecklistsSceneDelegate: AnyObject {
    func showSelectPlaneCompany()
    func showMyGroupChecklist(items: [ChecklistWithItemsModel])
}

protocol ChecklistsViewModelInterface {
    func onViewWillAppear()
    func onTapFindButton()
    func onTapEdit()
    func onSelect(item: ChecklistGroupStorageModel)
    func onDelete(item: ChecklistGroupStorageModel)
}

final class ChecklistsViewModel {
    weak var view: ChecklistsViewInterface!
    weak var output: ChecklistsSceneDelegate?

    @UserDataStorage(key: UserDefaultsKey.savedChecklists) private var savedChecklists: [ChecklistGroupStorageModel]?

    private var checklistsItems = [ChecklistGroupStorageModel]()
    private var isEditMode = false
}

// MARK: - ChecklistsViewModelInterface
extension ChecklistsViewModel: ChecklistsViewModelInterface {
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
        output?.showMyGroupChecklist(items: item.checklists)
    }

    func onDelete(item: ChecklistGroupStorageModel) {
        if let index = checklistsItems.firstIndex(of: item) {
            checklistsItems.remove(at: index)
            savedChecklists = checklistsItems
            view.updateState(checklistsItems.isEmpty ? .empty : .data(items: checklistsItems))
        }
    }
}
