//
//  SplashCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

class SplashCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let viewController = appDIContainer.makeSplashViewController()
        viewController.vm.delegate = self
        
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.viewControllers = [viewController]
    }
    
}

extension SplashCoordinator: SplashViewModelDelegate {
    
    func showWorkspaceView() {
        let workspaceSceneContainer = appDIContainer.makeWorkspaceSceneDIContainer()
        let coordinator = workspaceSceneContainer.makeWorkspaceHomeCoordinator(navigationController: navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showOnboardingView() {
        let signSceneDIContainer = appDIContainer.makeSignSceneDIContainer()
        let coordinator = signSceneDIContainer.makeOnboardingCoordinator(navigationController: navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
