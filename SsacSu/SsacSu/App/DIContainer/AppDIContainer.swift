//
//  AppDIContainer.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import Foundation
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
