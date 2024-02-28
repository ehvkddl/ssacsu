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
}
