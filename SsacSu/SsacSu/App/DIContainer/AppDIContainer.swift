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
            signProvider: getSignProvider(),
            userProvider: getUserProvider(),
            workspaceProvider: getWorkspaceProvider(),
            channelProvider: getChannelProvider(),
            dmsProvider: getDmsProvider()
        )
    }()
    
    lazy var accessTokenRefreshInterceptor = getAccessTokenRefreshInterceptor()

    // MARK: - DIContainers of scenes
    func makeSignSceneDIContainer() -> SignSceneDIContainer {
        let dependencies = SignSceneDIContainer.Dependencies(
            networkService: networkService
        )
        return SignSceneDIContainer(dependencies: dependencies)
    }
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(
            networkService: networkService
        )
        return TabBarDIContainer(dependencies: dependencies)
    }
    
    // MARK: - Splash
    func makeSplashViewController() -> SplashViewController {
        return SplashViewController.create(with: makeSplashViewModel())
    }
    
    func makeSplashViewModel() -> SplashViewModel {
        return SplashViewModel()
    }
    
    func makeSplashCoordinator(navigationController: UINavigationController) -> SplashCoordinator {
        return SplashCoordinator(
            navigationController: navigationController,
            appDIContainer: self
        )
    }
    
    // MARK: - Providers
    func getSignProvider() -> MoyaProvider<SignAPI> {
        return MoyaProvider<SignAPI>()
    }
    
    func getUserProvider() -> MoyaProvider<UserAPI> {
        return MoyaProvider<UserAPI>(
            session: Session(interceptor: accessTokenRefreshInterceptor)
        )
    }
    
    func getWorkspaceProvider() -> MoyaProvider<WorkspaceAPI> {
        return MoyaProvider<WorkspaceAPI>(
            session: Session(interceptor: accessTokenRefreshInterceptor)
        )
    }
    
    func getChannelProvider() -> MoyaProvider<ChannelAPI> {
        return MoyaProvider<ChannelAPI>(
            session: Session(interceptor: accessTokenRefreshInterceptor)
        )
    }
    
    func getDmsProvider() -> MoyaProvider<DmsAPI> {
        return MoyaProvider<DmsAPI>(
            session: Session(interceptor: accessTokenRefreshInterceptor)
        )
    }
    
    func getAccessTokenRefreshInterceptor() -> AccessTokenRefreshInterceptor {
        return AccessTokenRefreshInterceptor()
    }
    
}
