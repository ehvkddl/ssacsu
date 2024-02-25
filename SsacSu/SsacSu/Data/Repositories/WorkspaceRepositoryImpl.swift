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
    
    func fetchMyChannels(id: Int, completion: @escaping ([Channel]) -> Void) {
        networkService.processResponse(
            api: .workspace(.fetchMyChannels(id: id)),
            responseType: [ChannelResponseDTO].self) { response in
                switch response {
                case .success(let success):
                    print("채널 정보 불러옴!", success)
                    
                    let channels = success.map { $0.toDomain() }
                    channels.forEach { self.realmManager.addChannelInfo($0) }
                    
                    completion(channels)
                    
                case .failure(let failure):
                    print("채널 조회 실패", failure)
                }
            }
    }
    
}
