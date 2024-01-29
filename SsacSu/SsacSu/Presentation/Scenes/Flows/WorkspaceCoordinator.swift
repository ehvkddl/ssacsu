//
//  WorkspaceCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/30.
//

import UIKit

class WorkspaceCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private let workspaceSceneDIContainer: WorkspaceSceneDIContainer

    var type: CoordinatorType = .workspace
    
    init(navigationController: UINavigationController!,
         workspaceSceneDIContainer: WorkspaceSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.workspaceSceneDIContainer = workspaceSceneDIContainer
    }
    
    func start() {
        showWorkspaceHomeView()
    }
    
}

extension WorkspaceCoordinator {
    
    func showWorkspaceHomeView() {
        let viewController = workspaceSceneDIContainer.makeWorkspaceHomeViewController()
        
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.viewControllers = [viewController]
    }
    
}
