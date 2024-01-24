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
    
    // MARK: - Providers
    func getUserProvider() -> MoyaProvider<UserAPI> {
        return MoyaProvider<UserAPI>()
    }
    
    func getWorkspaceProvider() -> MoyaProvider<WorkspaceAPI> {
        return MoyaProvider<WorkspaceAPI>()
    }
}
