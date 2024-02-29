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
                    rooms.forEach { self.realmManager.addDMsRoomInfo($0) }
                    
                    completion(rooms)
                    
                case .failure(let failure):
                    print("DMsRoom 조회 실패", failure)
                }
            }
    }
    
    func fetchUnreadDms(id roomID: Int, completion: @escaping (Int) -> Void) {
        guard let room = realmManager.fetchSingleDMsRoom(of: roomID) else { print("#### DMsRoom 정보 없음"); return }
        
        let dateStr = {
            guard let date = realmManager.checkLastDMDate(of: roomID) else { return "" }
            
            return DateFormatter.iso8601.string(from: date)
        }()
        
        networkService.processResponse(
            api: .dms(.fetchUnreadDM(workspaceID: room.workspaceID,
                                     roomID: room.roomID,
                                     date: dateStr)),
            responseType: DMsChatUnreadsResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    completion(success.count)
                    
                case .failure(let failure):
                    print("DMsChatUnreads 조회 실패", failure)
                }
            }
    }
    
}
