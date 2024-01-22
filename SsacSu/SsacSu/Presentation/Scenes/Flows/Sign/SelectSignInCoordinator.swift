//
//  SelectSignInCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit

class SelectSignInCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    private let signSceneDIContainer: SignSceneDIContainer
    
    init(navigationController: UINavigationController!,
         signSceneDIContainer: SignSceneDIContainer
    ) {
        print("SelectSignInCoordinator init")
        self.navigationController = navigationController
        self.signSceneDIContainer = signSceneDIContainer
    }
    
    deinit {
        print("SelectSignInCoordinator deinit")
    }
    
    func start() {
        let viewController = signSceneDIContainer.makeSelectSignInMethodViewController()
        viewController.vm.delegate = self
        
        if let sheet = viewController.sheetPresentationController {
            var detent: UISheetPresentationController.Detent
            
            if #available(iOS 16.0, *) {
                detent = UISheetPresentationController.Detent.custom { _ in
                    return 270
                }
            } else {
                detent = .medium()
            }
            
            sheet.detents = [detent]
            sheet.prefersGrabberVisible = true
        }
        
        self.navigationController.present(viewController, animated: true)
    }
    
}

extension SelectSignInCoordinator: SelectSignInMethodViewModelDelegate {
    
    func signUp() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            let coordinator = signSceneDIContainer.makeSignUpCoordinator(navigationController: navigationController)
            self.childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
    
    func emailSignIn() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            let coordinator = signSceneDIContainer.makeEmailSignInCoordinator(navigationController: navigationController)
            self.childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
    
}
