//
//  SignCoordinator.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/30.
//

import UIKit

class SignCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .sign
    
    private let signSceneDIContainer: SignSceneDIContainer
    
    init(navigationController: UINavigationController,
         signSceneDIContainer: SignSceneDIContainer
    ) {
        self.navigationController = navigationController
        self.signSceneDIContainer = signSceneDIContainer
    }
    
    func start() {
        showOnboardingView()
    }
}

extension SignCoordinator: OnboardingViewControllerDelegate {
    
    func showOnboardingView() {
        let viewController = signSceneDIContainer.makeOnboardingViewController()
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func startSsacsu() {
        showSelectSignInView()
    }
    
}

extension SignCoordinator: SelectSignInMethodViewModelDelegate {
    
    func showSelectSignInView() {
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
    
    func socialLogin() {
        self.finish()
        self.navigationController.dismiss(animated: true)
    }
    
    func signUp() {
        self.navigationController.dismiss(animated: true) { [unowned self] in
            showSignUpView()
        }
    }
    
    func emailSignIn() {
        self.navigationController.dismiss(animated: true) { [unowned self] in
            showEmailSignInView()
        }
    }
    
}

extension SignCoordinator: EmailSignInViewModelDelegate {
    
    func showEmailSignInView() {
        let viewController = signSceneDIContainer.makeEmailSignInViewController()
        viewController.vm.delegate = self
        
        viewController.title = "이메일 로그인"
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeButtonClicked))
        
        let nav = UINavigationController(rootViewController: viewController)
        
        self.navigationController.present(nav, animated: true)
    }
    
    func login() {
        print("메인뷰 ㄱ")
        self.finish()
        self.navigationController.dismiss(animated: true)
    }
    
}

extension SignCoordinator {
    
    func showSignUpView() {
        let viewController = signSceneDIContainer.makeSignUpViewController()
        viewController.title = "회원가입"
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(closeButtonClicked))
        
        let nav = UINavigationController(rootViewController: viewController)
        
        self.navigationController.present(nav, animated: true)
    }
    
}

extension SignCoordinator {
    
    @objc func closeButtonClicked() {
        self.navigationController.dismiss(animated: true)
    }
    
}
