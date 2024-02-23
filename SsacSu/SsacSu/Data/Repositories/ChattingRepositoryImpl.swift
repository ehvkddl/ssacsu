//
//  ChannelChattingRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/22.
//

import Foundation

import RxSwift

final class ChattingRepositoryImpl {
    
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

extension ChattingRepositoryImpl: ChattingRepository {
    
    func fetchChat(of channelID: Int, completion: @escaping ([ChannelChat]) -> Void) {
    }
    
}

