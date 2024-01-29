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
    
    private func showSplashView() {
        let coordinator = appDIContainer.makeSplashCoordinator(
            navigationController: navigationController
        )
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
