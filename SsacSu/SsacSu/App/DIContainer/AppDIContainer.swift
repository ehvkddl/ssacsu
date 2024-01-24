//
//  AppDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import UIKit
import Moya

final class AppDIContainer {
    
    lazy var networkService: NetworkService = {
        return NetworkServiceImpl(
            userProvider: getUserProvider(),
            workspaceProvider: getWorkspaceProvider()
        )
    }()

    func makeSignSceneDIContainer() -> SignSceneDIContainer {
        let dependencies = SignSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return SignSceneDIContainer(dependencies: dependencies)
    }
    
    func makeWorkspaceSceneDIContainer() -> WorkspaceSceneDIContainer {
        let dependencies = WorkspaceSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return WorkspaceSceneDIContainer(dependencies: dependencies)
    }
    
    func makeSplashViewController() -> SplashViewController {
        return SplashViewController.create(with: makeSplashViewModel())
    }
    
    func makeSplashViewModel() -> SplashViewModel {
        let container = makeWorkspaceSceneDIContainer()
        let repository = container.getWorkspaceRepository()
        
        return SplashViewModel(
            workspaceRepository: repository
        )
    }
    
    func makeSplashCoordinator(navigationController: UINavigationController) -> SplashCoordinator {
        return SplashCoordinator(
            navigationController: navigationController,
            appDIContainer: self
        )
    }
    
    // MARK: - Providers
    func getUserProvider() -> MoyaProvider<UserAPI> {
        return MoyaProvider<UserAPI>()
    }
    
    func getWorkspaceProvider() -> MoyaProvider<WorkspaceAPI> {
        let accessTokenRefreshInterceptor = getAccessTokenRefreshInterceptor()
        
        return MoyaProvider<WorkspaceAPI>(
            session: Session(interceptor: accessTokenRefreshInterceptor)
        )
    }
    
    func getAccessTokenRefreshInterceptor() -> AccessTokenRefreshInterceptor {
        return AccessTokenRefreshInterceptor()
    }
    
}
