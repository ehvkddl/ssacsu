//
//  SignUpCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/19.
//

import UIKit

class SignUpCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    private let signSceneDIContainer: SignSceneDIContainer
    
    init(navigationController: UINavigationController!,
         signSceneDIContainer: SignSceneDIContainer
    ) {
        print("SignUpCoordinator init")
        self.navigationController = navigationController
        self.signSceneDIContainer = signSceneDIContainer
    }
    
    deinit {
        print("SignUpCoordinator deinit")
    }
    
    func start() {
        let viewController = signSceneDIContainer.makeSignUpViewController()
        viewController.title = "회원가입"
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeButtonClicked))
        
        let nav = UINavigationController(rootViewController: viewController)
        
        self.navigationController.present(nav, animated: true)
    }
    
}

extension SignUpCoordinator {
    
    @objc func closeButtonClicked() {
        self.navigationController.dismiss(animated: true)
    }
    
}
