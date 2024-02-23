//
//  RealmManager.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import Foundation
import RealmSwift

protocol RealmManager {
    func checkLastDate(of channelID: Int) -> Date?
    func fetchSingleChannel(of channelID: Int) -> ChannelTB?
    func fetchChat(of channelID: Int) -> [ChannelChat]
    func addChat(to channelID: Int, _ item: ChannelChatResponseDTO)
}

final class RealmManagerImpl: RealmManager {
    
    private let realm: Realm? = {
        do {
            print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
            return try Realm()
        } catch {
            print("Failed to Realm load")
            
            return nil
        }
    }()

    // MARK: - 마지막 채팅 날짜 확인
    func checkLastDate(of channelID: Int) -> Date? {
        guard let realm else { return nil }
        
        guard let channel = fetchSingleChannel(of: channelID) else { return nil }
        
        guard let lastChat = channel.channelChats
            .sorted(byKeyPath: "createdAt", ascending: true)
            .last else { return nil }
        
        return lastChat.createdAt
    }
    
    // MARK: - channelID의 채널 정보 가져오기
    func fetchSingleChannel(of channelID: Int) -> ChannelTB? {
        guard let realm else { return nil }
        
        return realm.object(ofType: ChannelTB.self, forPrimaryKey: channelID)
    }
    
    // MARK: - channelID의 채널 채팅 30개 가져오기
    func fetchChat(of channelID: Int) -> [ChannelChat] {
        guard let realm else { return [] }
        
        guard let channel = realm.object(ofType: ChannelTB.self, forPrimaryKey: channelID) else { return [] }
        
        let chats = channel.channelChats
            .sorted(byKeyPath: "createdAt", ascending: true)
            .suffix(30)
        
        let chatsArr = Array(chats.map { $0.toDomain() })
        
        return chatsArr
    }
    
    // MARK: - 채팅 저장
    func addChat(to channelID: Int, _ item: ChannelChatResponseDTO) {
        guard let realm else { return }
        
        guard let channel = fetchSingleChannel(of: channelID) else {
            print("채널 없음")
            return
        }
        
        let files = List<String>()
        item.files.forEach(files.append)
        
        let user: UserTB = {
            guard let existUser = realm.object(ofType: UserTB.self, forPrimaryKey: item.user.userID) else {
                return UserTB(userID: item.user.userID,
                              email: item.user.email,
                              nickname: item.user.nickname,
                              profileImage: item.user.profileImage)
            }
            
            return existUser
        }()

        guard realm.object(ofType: ChannelChatTB.self, forPrimaryKey: item.chatId) == nil else { return }
        
        let chat = ChannelChatTB(
            chatID: item.chatId,
            content: item.content,
            createdAt: DateFormatter.iso8601.date(from: item.createdAt) ?? Date(),
            files: files,
            user: user
        )
        
        do {
            try realm.write {
                channel.channelChats.append(chat)
                realm.add(channel, update: .modified)
                print("채팅 저장", channel.channelChats)
            }
        } catch {
            print("채팅 저장 실패", error)
        }
    }
    
}
