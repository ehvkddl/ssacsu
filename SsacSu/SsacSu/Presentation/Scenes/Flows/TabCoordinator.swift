//
//  TabCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/30.
//

import UIKit

enum TabBarPage {
    case home
    case dm
    case search
    case setting

    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .dm
        case 2: self = .search
        case 3: self = .setting
        default: return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home: return "홈"
        case .dm: return "DM"
        case .search: return "검색"
        case .setting: return "설정"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .dm: return 1
        case .search: return 2
        case .setting: return 3
        }
    }

    func tabIcon() -> UIImage {
        switch self {
        case .home: return .TabItem.home
        case .dm: return .TabItem.message
        case .search: return .TabItem.profile
        case .setting: return .TabItem.setting
        }
    }

}

class TabCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print(childCoordinators)
        }
    }

    let type: CoordinatorType = .main
    
    private let workspaceSceneDIContainer: WorkspaceSceneDIContainer
    
    var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController,
         workspaceSceneDIContainer: WorkspaceSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.workspaceSceneDIContainer = workspaceSceneDIContainer
        
        self.tabBarController = .init()
    }
    
    func start() {
        let pages: [TabBarPage] = [.home, .dm, .search, .setting]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        let controllers: [UINavigationController] = pages.map { getTabController($0) }
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: false)
        
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()

        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .Brand.black
        tabBarController.tabBar.backgroundColor = .Background.secondary

        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.tabIcon(),
                                                     tag: page.pageOrderNumber())

        switch page {
        case .home:
            let coordinator = workspaceSceneDIContainer.makeWorkspaceCoordinator(navigationController: navController)
            self.childCoordinators.append(coordinator)
            coordinator.start()
            
        case .dm:
            let vc = UIViewController()
            vc.view.backgroundColor = .systemYellow
            navController.pushViewController(vc, animated: true)

        case .search:
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBlue
            navController.pushViewController(vc, animated: true)
            
        case .setting:
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBrown
            navController.pushViewController(vc, animated: true)
        }
        
        return navController
    }
    
}
