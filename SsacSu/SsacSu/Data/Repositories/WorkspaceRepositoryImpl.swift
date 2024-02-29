//
//  WorkspaceRepositoryImpl.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import RxSwift

final class WorkspaceRepositoryImpl {
    
    private let realmManager: RealmManager
    private let networkService: NetworkService
    
    init(
        realmManager: RealmManager,
        networkService: NetworkService
    ) {
        self.realmManager = realmManager
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
    
    func fetchSingleWorkspace(id: Int, completion: @escaping (Workspace) -> Void) {
        print(#function)
        
        return networkService.processResponse(
            api: .workspace(WorkspaceAPI.fetchSingleWorkspace(id: id)),
            responseType: WorkspaceResponseDTO.self) { response in
                switch response {
                case .success(let success):
                    completion(success.toDomain())
                    
                case .failure(let failure):
                    print("워크스페이스 조회 실패", failure)
                }
            }
    }
    
}
