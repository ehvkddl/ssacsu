//
//  EmailSignInCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit

class EmailSignInCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    private let signSceneDIContainer: SignSceneDIContainer
    
    init(navigationController: UINavigationController!,
         signSceneDIContainer: SignSceneDIContainer
    ) {
        print("EmailSignInCoordinator init")
        self.navigationController = navigationController
        self.signSceneDIContainer = signSceneDIContainer
    }
    
    deinit {
        print("EmailSignInCoordinator deinit")
    }
    
    func start() {
        let viewController = signSceneDIContainer.makeEmailSignInViewController()
        let nav = UINavigationController(rootViewController: viewController)
        
        viewController.title = "이메일 로그인"
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeButtonClicked))
        
        self.navigationController.present(nav, animated: true)
    }
    
}

extension EmailSignInCoordinator {
    
    @objc func closeButtonClicked() {
        self.navigationController.dismiss(animated: true)
    }
    
}
