//
//  ChattingCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

class ChannelChattingCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let channelChattingSceneDIContainer: ChannelChattingSceneDIContainer
    
    var type: CoordinatorType = .workspace
    
    init(navigationController: UINavigationController!,
         channelChattingSceneDIContainer: ChannelChattingSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.channelChattingSceneDIContainer = channelChattingSceneDIContainer
    }
    
    var channel: Channel?
    
    func start() {
        showChattingView()
    }
    
}

extension ChannelChattingCoordinator: ChattingViewModelDelegate {
    
    func showChattingView() {
        let vc = channelChattingSceneDIContainer.makeChattingViewController()
        vc.vm.delegate = self
        
        guard let channel else { return }
        vc.vm.channel.accept(channel)
        
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backButtonTapped() {
        navigationController.popViewController(animated: true)
    }
    
}
