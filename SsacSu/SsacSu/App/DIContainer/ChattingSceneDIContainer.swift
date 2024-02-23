//
//  ChattingSceneDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

final class ChattingSceneDIContainer {
    
    struct Dependencies {
        let realmManager: RealmManager
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Chatting
    func makeChattingViewController() -> ChattingViewController {
        return ChattingViewController.create(
            with: makeChattingViewModel()
        )
    }
    
    func makeChattingViewModel() -> ChattingViewModel {
        return ChattingViewModel(
            chattingRepository: getChattingRepository()
        )
    }
    
    // MARK: - Repositories
    func getChattingRepository() -> ChattingRepository {
        return ChattingRepositoryImpl(
            realmManager: dependencies.realmManager,
            networkService: dependencies.networkService
        )
    }
    
    // MARK: - Flow Coordinators
    func makeChattingCoordinator(navigationController: UINavigationController) -> ChattingCoordinator {
        return ChattingCoordinator(
            navigationController: navigationController,
            chattingSceneDIContainer: self
        )
    }
    
}
