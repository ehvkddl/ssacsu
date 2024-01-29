//
//  AppCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit

class AppCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    let type: CoordinatorType = .app
    
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        self.showSplashView()
    }
    
}

extension AppCoordinator {
    
    private func showSplashView() {
        let coordinator = appDIContainer.makeSplashCoordinator(
            navigationController: navigationController
        )
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func showSignFlow() {
        let signSceneDIContainer = appDIContainer.makeSignSceneDIContainer()
        let coordinator = signSceneDIContainer.makeSignCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func showMainFlow() {
        let tabBarDIContainer = appDIContainer.makeTabBarDIContainer()
        let coordinator = tabBarDIContainer.makeTabCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator, next: CoordinatorType?) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

        switch childCoordinator.type {
        case .splash:
            guard let next else { return }
            
            switch next {
            case .sign:
                print("스플래시 -> 싸인")
                navigationController.viewControllers.removeAll()
                showSignFlow()

            case .main:
                print("스플래시 -> 메인")
                navigationController.viewControllers.removeAll()
                showMainFlow()
                
            default:
                break
            }
            
        case .sign:
            print("sign flow 슈융")
            navigationController.viewControllers.removeAll()

            showMainFlow()
            
        case .main:
            print("main flow 슈슝")
            navigationController.viewControllers.removeAll()

            showSignFlow()
            
        default:
            print("빠져버렷어용")
            break
        }
    }
    
}
