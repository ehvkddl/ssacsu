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
    func addChannelInfo(_ channel: Channel)
    func fetchChat(of channelID: Int) -> Results<ChannelChatTB>?
    func fetchChat(of channelID: Int, _ count: Int) -> [ChannelChat]
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
        guard let chats = fetchChat(of: channelID) else { return nil }
        guard let lastChat = chats
            .sorted(byKeyPath: "createdAt", ascending: true)
            .last else { return nil }
        
        return lastChat.createdAt
    }
    
    // MARK: - channelID의 채널 정보 가져오기
    func fetchSingleChannel(of channelID: Int) -> ChannelTB? {
        guard let realm else { return nil }
        
        return realm.object(ofType: ChannelTB.self, forPrimaryKey: channelID)
    }
    
    // MARK: - 채널 정보 저장
    func addChannelInfo(_ channel: Channel) {
        guard let realm else { return }
        
        let channel = ChannelTB(channelID: channel.channelID,
                                workspaceID: channel.workspaceID,
                                name: channel.name,
                                _description: channel.description,
                                ownerID: channel.ownerID,
                                isPrivate: channel.isPrivate,
                                createdAt: channel.createdAt)
        
        do {
            try realm.write {
                realm.add(channel, update: .modified)
                print("채널 정보 저장", channel)
            }
        } catch {
            print("채널 정보 저장 실패", error)
        }
    }
    
    // MARK: - channelID의 채널 모든 채팅 가져오기
    func fetchChat(of channelID: Int) -> Results<ChannelChatTB>? {
        guard let realm else { return nil }
        
        return realm.objects(ChannelChatTB.self)
            .filter("channel.channelID == \(channelID)")
            .sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    // MARK: - channelID의 채널 채팅 30개 가져오기
    func fetchChat(of channelID: Int, _ count: Int) -> [ChannelChat] {
        guard let chats = fetchChat(of: channelID) else { return [] }
        let countChats = chats.suffix(count)

        let chatsArr = Array(countChats.map { $0.toDomain() })
        
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

        let user = UserTB(userID: item.user.userID,
                          email: item.user.email,
                          nickname: item.user.nickname,
                          profileImage: item.user.profileImage)
        
        let chat = ChannelChatTB(
            chatID: item.chatId,
            content: item.content,
            createdAt: DateFormatter.iso8601.date(from: item.createdAt) ?? Date(),
            files: files,
            channel: channel,
            user: user
        )
        
        do {
            try realm.write {
                realm.add(chat, update: .modified)
                print("채팅 저장", chat)
            }
        } catch {
            print("채팅 저장 실패", error)
        }
    }
    
}
