//
//  DmsRepositoryImpl.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

final class DmsRepositoryImpl: DmsRepository {
    
    private let realmManager: RealmManager
    private let socketManager: SocketIOManager
    private let networkService: NetworkService
    
    init(
        realmManager: RealmManager,
        socketManager: SocketIOManager,
        networkService: NetworkService
    ) {
        self.realmManager = realmManager
        self.socketManager = socketManager
        self.networkService = networkService
    }
    
}

extension DmsRepositoryImpl {
    
    func fetchDmsRoom(id workspaceID: Int, completion: @escaping ([DMsRoom]) -> Void) {
        networkService.processResponse(
            api: .dms(.fetchDMsRoom(workspaceID: workspaceID)),
            responseType: [DMsRoomResponseDTO].self) { result in
                switch result {
                case .success(let success):
                    let rooms = success.map { $0.toDomain() }
                    
                    completion(rooms)
                    
                case .failure(let failure):
                    print("DMsRoom 조회 실패", failure)
                }
            }
    }
    
}
