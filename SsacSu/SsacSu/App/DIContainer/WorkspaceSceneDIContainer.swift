//
//  WorkspaceSceneDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

final class WorkspaceSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Initial
    func makeWorkspaceInitialViewController() -> WorkspaceInitialViewController {
        WorkspaceInitialViewController.create(
            with: makeWorkspaceInitialViewModel()
        )
    }
    
    func makeWorkspaceInitialViewModel() -> WorkspaceInitialViewModel {
        return WorkspaceInitialViewModel()
    }
    
    // MARK: - Home
    func makeWorkspaceHomeViewController() -> WorkspaceHomeViewController {
        return WorkspaceHomeViewController.create(
            with: makeWorkspaceHomeViewModel()
        )
    }
    
    func makeWorkspaceHomeViewModel() -> WorkspaceHomeViewModel {
        return WorkspaceHomeViewModel()
    }
    
    // MARK: - Repositories
    func getWorkspaceRepository() -> WorkspaceRepository {
        return WorkspaceRepositoryImpl(networkService: dependencies.networkService)
    }
    
}
