//
//  ChattingCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/19.
//

import UIKit

class ChattingCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let chattingSceneDIContainer: ChattingSceneDIContainer
    
    var type: CoordinatorType = .workspace
    
    init(navigationController: UINavigationController!,
         chattingSceneDIContainer: ChattingSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.chattingSceneDIContainer = chattingSceneDIContainer
    }
    
    func start() {
        showChattingView()
    }
    
}

extension ChattingCoordinator: ChattingViewModelDelegate {
    
    func showChattingView() {
        let vc = chattingSceneDIContainer.makeChattingViewController()
        vc.vm.delegate = self
        
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backButtonTapped() {
        navigationController.popViewController(animated: true)
    }
    
}
