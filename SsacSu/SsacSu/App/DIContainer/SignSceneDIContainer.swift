//
//  SignSceneDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit

final class SignSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        OnboardingViewController.create()
    }
    
    func makeSelectSignInMethodViewController() -> SelectSignInMethodViewController {
        SelectSignInMethodViewController.create(
            with: makeSelectSignInMethodViewModel()
        )
    }
    
    func makeSelectSignInMethodViewModel() -> SelectSignInMethodViewModel {
        SelectSignInMethodViewModel(
            signRepository: getSignRepository(),
            appleLoginRepository: getAppleLoginRepository(),
            kakaoLoginRepository: getKakaoLoginRepository()
        )
    }
    
    func makeEmailSignInViewController() -> EmailSignInViewController {
        EmailSignInViewController.create(with: makeEmailSignInViewModel())
    }
    
    func makeEmailSignInViewModel() -> EmailSignInViewModel {
        EmailSignInViewModel(
            signRepository: getSignRepository()
        )
    }
    
    func makeSignUpViewController() -> SignUpViewController {
        SignUpViewController.create(with: makeSignUpViewModel())
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(
            signRepository: getSignRepository()
        )
    }
    
    func getSignRepository() -> SignRepository {
        return SignRepositoryImpl(networkService: dependencies.networkService)
    }
    
    func getAppleLoginRepository() -> AppleLoginRepository {
        return AppleLoginRepositoryImpl()
    }
    
    func getKakaoLoginRepository() -> KakaoLoginRepository {
        return KakaoLoginRepositoryImpl()
    }
    
    func makeOnboardingCoordinator(navigationController: UINavigationController) -> OnboardingCoordinator {
        OnboardingCoordinator(
            navigationController: navigationController,
            signSceneDIContainer: self
        )
    }
    
    func makeSelectSignInCoordinator(navigationController: UINavigationController) -> SelectSignInCoordinator {
        SelectSignInCoordinator(
            navigationController: navigationController, 
            signSceneDIContainer: self
        )
    }
    
    func makeSignUpCoordinator(navigationController: UINavigationController) -> SignUpCoordinator {
        SignUpCoordinator(
            navigationController: navigationController,
            signSceneDIContainer: self
        )
    }
    
    func makeEmailSignInCoordinator(navigationController: UINavigationController) -> EmailSignInCoordinator {
        EmailSignInCoordinator(
            navigationController: navigationController,
            signSceneDIContainer: self
        )
    }
    
}
