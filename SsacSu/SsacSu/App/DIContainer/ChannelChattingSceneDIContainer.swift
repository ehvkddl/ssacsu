//
//  ChattingSceneDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

final class ChannelChattingSceneDIContainer {
    
    struct Dependencies {
        let channelRepository: ChannelRepository
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
            channelRepository: dependencies.channelRepository
        )
    }
    
    // MARK: - Flow Coordinators
    func makeChattingCoordinator(navigationController: UINavigationController) -> ChannelChattingCoordinator {
        return ChannelChattingCoordinator(
            navigationController: navigationController,
            channelChattingSceneDIContainer: self
        )
    }
    
}
