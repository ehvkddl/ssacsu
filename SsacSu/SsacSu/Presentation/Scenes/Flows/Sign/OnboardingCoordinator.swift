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
    private let signSceneDIContainer: SignSceneDIContainer
    
    init(navigationController: UINavigationController,
         signSceneDIContainer: SignSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.signSceneDIContainer = signSceneDIContainer
    }
    
    func start() {
        let viewController = signSceneDIContainer.makeOnboardingViewController()
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func startSsacsu() {
        let coordinator = signSceneDIContainer.makeSelectSignInCoordinator(navigationController: navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
