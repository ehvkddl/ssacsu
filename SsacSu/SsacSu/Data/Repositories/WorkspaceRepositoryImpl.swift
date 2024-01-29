//
//  WorkspaceRepositoryImpl.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxSwift

final class WorkspaceRepositoryImpl {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
}

extension WorkspaceRepositoryImpl: WorkspaceRepository {
    
    func fetchWorkspace() -> Single<Result<WorkspaceList, SsacsuError>> {
        print("workspace 조회")
        return networkService.processResponse(
            api: .workspace(WorkspaceAPI.fetchWorkspace),
            responseType: WorkspaceList.self
        )
    }
    
    func fetchSingleWorkspace(id: Int) -> Single<Result<WorkspaceResponseDTO, SsacsuError>> {
        print(#function)
        return networkService.processResponse(
            api: .workspace(WorkspaceAPI.fetchSingleWorkspace(id: id)),
            responseType: WorkspaceResponseDTO.self
        )
    }
    
}
