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
        guard let channel = realmManager.fetchSingleChannel(of: channelID) else {
            print("#### 채널 정보 없음")
            return
        }
        
        let dateStr = {
            guard let date = realmManager.checkLastDate(of: channelID) else { return "" }
            
            return DateFormatter.iso8601.string(from: date)
        }()
        
        // DB에 채팅 기록 있으면 마지막 채팅 이후 데이터 불러오기. 없으면 전체 채팅 데이터 불러오기.
        networkService.processResponse(
            api: .channel(.fetchChats(workspaceID: channel.workspaceID, 
                                      channelName: channel.name,
                                      date: dateStr)),
            responseType: [ChannelChatResponseDTO].self) { [unowned self] response in
                switch response {
                case .success(let success):
                    success.forEach { realmManager.addChat(to: channelID, $0) }
                    
                    let chats = realmManager.fetchChat(of: channelID)
                    completion(chats)
                    
                case .failure(let failure):
                    print("채팅 불러오기 실패", failure)
                }
            }

    }
    
    }
    
}

