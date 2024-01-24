//
//  WorkspaceInitialCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

class WorkspaceInitialCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
 
    private var navigationController: UINavigationController!
    private var workspaceSceneDIContainer: WorkspaceSceneDIContainer
    
    init(navigationController: UINavigationController!,
         workspaceSceneDIContainer: WorkspaceSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.workspaceSceneDIContainer = workspaceSceneDIContainer
    }
    
    func start() {
        let viewController = workspaceSceneDIContainer.makeWorkspaceInitialViewController()
        
        self.navigationController.viewControllers = [viewController]
    }
    
}

