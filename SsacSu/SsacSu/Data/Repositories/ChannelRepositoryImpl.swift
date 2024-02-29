//
//  ChannelChattingRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/22.
//

import Foundation

import RxSwift

final class ChannelRepositoryImpl {
    
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

extension ChannelRepositoryImpl: ChannelRepository {
    
    func fetchMyChannels(id workspaceID: Int, completion: @escaping ([Channel]) -> Void) {
        networkService.processResponse(
            api: .channel(.fetchMyChannels(id: workspaceID)),
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
    
    func fetchUnreadChannelChat(id channelID: Int, completion: @escaping (Int) -> Void) {
        guard let channel = realmManager.fetchSingleChannel(of: channelID) else { print("#### Channel 정보 없음"); return }
        
        let dateStr = {
            guard let date = realmManager.checkLastDate(of: channelID) else { return "" }
            
            return DateFormatter.iso8601.string(from: date)
        }()
        
        networkService.processResponse(
            api: .channel(.fetchUnreadChannelChat(workspaceID: channel.workspaceID, 
                                                  channelName: channel.name,
                                                  date: dateStr)),
            responseType: ChannelChatUnreadsResponseDTO.self) { result in
                switch result {
                case .success(let success):
                    completion(success.count)
                    
                case .failure(let failure):
                    print("ChannelChatUnreads 조회 실패", failure)
                }
            }
    }
    
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
                    
                    let chats = realmManager.fetchChat(of: channelID, 30)
                    completion(chats)
                    
                case .failure(let failure):
                    print("채팅 불러오기 실패", failure)
                }
            }

    }
    
    func createChat(of channelID: Int, chat: ChannelChatRequestDTO, completion: @escaping (ChannelChat) -> Void) {
        guard let channel = realmManager.fetchSingleChannel(of: channelID) else {
            print("#### 채널 정보 없음")
            return
        }
        
        networkService.processResponse(
            api: .channel(.createChat(workspaceID: channel.workspaceID,
                                      channelName: channel.name,
                                      chat: chat)),
            responseType: ChannelChatResponseDTO.self) { [unowned self] response in
            switch response {
            case .success(let success):
                print("@@@ 채팅 생성 성공!!")
                print(success)
                
                realmManager.addChat(to: channelID, success)
                
                completion(success.toDomain())
                
            case .failure(let failure):
                print("@@@ 채팅 생성 실패!!", failure)
                print(failure)
            }
        }
    }
    
}

extension ChannelRepositoryImpl {
    
    func openSocket(id channelID: Int, completion: @escaping (ChannelChat) -> ()) {
        socketManager.open(id: channelID) { [unowned self] chat in
            print("ChattingRepositoryImpl 채팅 받아옴~")
            // 채팅 수신 후 DB 저장
            // 내가 보낸 채팅은 저장 X
            let loginUser = UserDefaultsManager.user
            guard loginUser.userID != -1,
                  loginUser.userID != chat.user.userID else { return }
            
            realmManager.addChat(to: channelID, chat)
            
            completion(chat.toDomain())
        }
    }
    
    func closeSocket() {
        socketManager.close()
    }
    
}
