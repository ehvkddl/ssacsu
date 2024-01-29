//
//  SplashCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

class SplashCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .splash
    
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
        
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.viewControllers = [viewController]
    }
    
}

extension SplashCoordinator: SplashViewModelDelegate {
    
    func logout() {
        print("logout")
        self.finish(next: .sign)
    }
    
    func login() {
        print("login")
        self.finish(next: .main)
    }
    
}
