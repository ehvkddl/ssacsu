//
//  WorkspaceHomeCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import UIKit

class WorkspaceHomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    private let workspaceSceneDIContainer: WorkspaceSceneDIContainer
    
    init(navigationController: UINavigationController!,
         workspaceSceneDIContainer: WorkspaceSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.workspaceSceneDIContainer = workspaceSceneDIContainer
    }
    
    func start() {
        let viewController = workspaceSceneDIContainer.makeWorkspaceHomeViewController()
        
        self.navigationController.viewControllers = [viewController]
    }
    
}
