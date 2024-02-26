//
//  TabBarDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/30.
//

import UIKit

final class TabBarDIContainer {
    
    lazy var realmManager: RealmManager = {
        return RealmManagerImpl()
    }()
    
    lazy var socketManager: SocketIOManager = {
        return SocketIOManager.shared
    }()
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
 
    func makeWorkspaceSceneDIContainer() -> WorkspaceSceneDIContainer {
        let dependencies = WorkspaceSceneDIContainer.Dependencies(
            realmManager: realmManager,
            socketManager: socketManager,
            networkService: dependencies.networkService
        )
        return WorkspaceSceneDIContainer(dependencies: dependencies)
    }
    
    func makeTabCoordinator(navigationController: UINavigationController) -> TabCoordinator {
        let workspaceSceneDIContainer = makeWorkspaceSceneDIContainer()
        
        return TabCoordinator(
            navigationController: navigationController,
            workspaceSceneDIContainer: workspaceSceneDIContainer
        )
    }
    
}
