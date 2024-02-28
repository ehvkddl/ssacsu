//
//  WorkspaceSceneDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

final class WorkspaceSceneDIContainer {
    
    private lazy var channelRepository = getChannelRepository()
    private lazy var dmsRepository = getDmsRespository()
    
    struct Dependencies {
        let realmManager: RealmManager
        let socketManager: SocketIOManager
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeChattingSceneDIContainer() -> ChannelChattingSceneDIContainer {
        let dependencies = ChannelChattingSceneDIContainer.Dependencies(
            channelRepository: channelRepository
        )
        return ChannelChattingSceneDIContainer(dependencies: dependencies)
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
        return WorkspaceHomeViewModel(
            userRepository: getUserRepository(),
            workspaceRepository: getWorkspaceRepository(),
            channelRepository: channelRepository,
            dmsRepository: dmsRepository
        )
    }
    
    // MARK: List
    func makeWorkspaceListViewController() -> WorkspaceListViewController {
        return WorkspaceListViewController.create(
            with: makeWorkspaceListViewModel()
        )
    }
    
    func makeWorkspaceListViewModel() -> WorkspaceListViewModel {
        return WorkspaceListViewModel(
            workspaceRepository: getWorkspaceRepository()
        )
    }
    
    // MARK: - Repositories
    func getUserRepository() -> UserRepository {
        return UserRepositoryImpl(
            networkService: dependencies.networkService
        )
    }
    
    func getWorkspaceRepository() -> WorkspaceRepository {
        return WorkspaceRepositoryImpl(
            realmManager: dependencies.realmManager,
            networkService: dependencies.networkService
        )
    }
    
    func getChannelRepository() -> ChannelRepository {
        return ChannelRepositoryImpl(
            realmManager: dependencies.realmManager,
            socketManager: dependencies.socketManager,
            networkService: dependencies.networkService
        )
    }
    
    func getDmsRespository() -> DmsRepository {
        return DmsRepositoryImpl(
            realmManager: dependencies.realmManager,
            socketManager: dependencies.socketManager,
            networkService: dependencies.networkService
        )
    }
    
    // MARK: - Flow Coordinators
    func makeWorkspaceCoordinator(navigationController: UINavigationController) -> WorkspaceCoordinator {
        return WorkspaceCoordinator(
            navigationController: navigationController,
            workspaceSceneDIContainer: self
        )
    }
    
}
