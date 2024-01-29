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
    
    // MARK: - Onboarding
    func makeOnboardingViewController() -> OnboardingViewController {
        OnboardingViewController.create()
    }
    
    // MARK: - Select SignIn Method
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
    
    // MARK: - Email SignIn
    func makeEmailSignInViewController() -> EmailSignInViewController {
        EmailSignInViewController.create(with: makeEmailSignInViewModel())
    }
    
    func makeEmailSignInViewModel() -> EmailSignInViewModel {
        EmailSignInViewModel(
            signRepository: getSignRepository()
        )
    }
    
    // MARK: - Email SignUp
    func makeSignUpViewController() -> SignUpViewController {
        SignUpViewController.create(with: makeSignUpViewModel())
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(
            signRepository: getSignRepository()
        )
    }
    
    // MARK: - Repositories
    func getSignRepository() -> SignRepository {
        return SignRepositoryImpl(networkService: dependencies.networkService)
    }
    
    func getAppleLoginRepository() -> AppleLoginRepository {
        return AppleLoginRepositoryImpl()
    }
    
    func getKakaoLoginRepository() -> KakaoLoginRepository {
        return KakaoLoginRepositoryImpl()
    }
    
    // MARK: - Flow Coordinators
    func makeSignCoordinator(navigationController: UINavigationController) -> SignCoordinator {
        SignCoordinator(
            navigationController: navigationController,
            signSceneDIContainer: self
        )
    }
    
}
