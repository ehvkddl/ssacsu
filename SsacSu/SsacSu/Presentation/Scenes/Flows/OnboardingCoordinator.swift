//
//  OngoardingCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit

class OnboardingCoordinator: Coordinator, OnboardingViewControllerDelegate {
    
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
        let viewController = OnboardingViewController()
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func startSsacsu() {
        let signSceneDIContainer = appDIContainer.makeSignSceneDIContainer()
        let coordinator = signSceneDIContainer.makeSelectSignInCoordinator(navigationController: navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
