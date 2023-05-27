//
//  TabCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

protocol TabCoordinatorInterface: Coordinatable {
    func selectPage(_ page: TabCoordinator.TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabCoordinator.TabBarPage?
}

protocol TabCoordinatorDelegate: AnyObject {
    func didLogoutUser(_ coordinator: TabCoordinator)
}

final class TabCoordinator: NSObject, TabCoordinatorInterface {
    enum TabBarPage: Int, CaseIterable {
        case airports
        case favourites
        case tools
        case settings

        fileprivate var tabBarItem: UITabBarItem {
            switch self {
            case .airports:
                return UITabBarItem(
                    title: "Airports",
                    image: UIImage(named: "tabbar_airports"),
                    selectedImage: UIImage(named: "tabbar_airports_selected")
                )
            case .favourites:
                return UITabBarItem(
                    title: "Favourites",
                    image: UIImage(named: "tabbar_favourites"),
                    selectedImage: UIImage(named: "tabbar_favourites_selected")
                )
            case .tools:
                return UITabBarItem(
                    title: "Tools",
                    image: UIImage(named: "tabbar_tools"),
                    selectedImage: UIImage(named: "tabbar_tools_selected")
                )
            case .settings:
                return UITabBarItem(
                    title: "Settings",
                    image: UIImage(named: "tabbar_settings"),
                    selectedImage: UIImage(named: "tabbar_settings")?.withTintColor(.black)
                )
            }
        }
    }

    private let notificationCenter = DIContainer.default.notificationService
    private var notificationTokens: [NotificationToken] = []
    private let navigationController: UINavigationController
    let tabBarController: UITabBarController
    private(set) var children: [Coordinatable]

    weak var startingViewController: UIViewController? { tabBarController }
    weak var parent: Coordinatable?

    weak var delegate: TabCoordinatorDelegate?

    required init(
        navigationController: UINavigationController,
        delegate: TabCoordinatorDelegate?
    ) {
        self.children = []
        self.delegate = delegate
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.tabBarController.view.backgroundColor = .white
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .black
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        super.init()
        subscribeOnNotifications()
    }

    func start() {
        let controllers: [UINavigationController] = TabBarPage.allCases.map({ getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
    }

    deinit {
        children.removeAll()
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.allCases.first?.rawValue ?? 0
        tabBarController.tabBar.isTranslucent = false
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [tabBarController]
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = BaseNavigationController()
        navigationController.tabBarItem = page.tabBarItem
        
        let router = Router(rootController: navigationController)

        switch page {
        case .airports:
            let airportsCoordinator = AirportsCoordinator(router: router)
            airportsCoordinator.parent = self
            children.append(airportsCoordinator)
            airportsCoordinator.start()
        case .favourites:
            let favoritesCoordinator = FavoritesCoordinator(router: router)
            favoritesCoordinator.parent = self
            children.append(favoritesCoordinator)
            favoritesCoordinator.start()
        case .tools:
            break
        case .settings:
            break
        }
        return navigationController
    }
    
    private func subscribeOnNotifications() {
        notificationTokens.append(
            notificationCenter.observe(
                name: .didSelectFavouriteAirport
            ) { [weak self] notification in
                self?.selectPage(.airports)
            }
        )
    }

    func currentPage() -> TabBarPage? {
        TabBarPage(rawValue: tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.rawValue
    }

    func setSelectedIndex(_ index: Int) {
        tabBarController.selectedIndex = index
    }
}

// MARK: - Coordinatable
extension TabCoordinator: Coordinatable {
    func add(_ child: Coordinatable) {
        for element in children where  child === element {
            return
        }
        children.append(child)
    }

    func remove(_ child: Coordinatable) {
        guard !children.isEmpty else { return }
        for (index, element) in children.enumerated() where element === child {

            children.remove(at: index)
            break
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        // Some implementation
    }
}
