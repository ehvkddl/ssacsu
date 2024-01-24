//
//  AppCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    
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
