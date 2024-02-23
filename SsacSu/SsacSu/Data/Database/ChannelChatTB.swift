//
//  ChannelChatTB.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import Foundation

import RealmSwift

final class ChannelChatTB: Object {
    @Persisted(primaryKey: true) var chatID: Int
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted var user: UserTB?
    
    @Persisted(originProperty: "channelChats") var channel: LinkingObjects<ChannelTB>
    
    convenience init(
        chatID: Int,
        content: String?,
        createdAt: Date,
        files: List<String>,
        user: UserTB
    ) {
        self.init()
        
        self.chatID = chatID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

extension ChannelChatTB {
    func toDomain() -> ChannelChat {
        let files: [String] = {
            self.files.map { $0 }
        }()
        
        return .init(
            chatId: chatID,
            content: content,
            createdAt: createdAt,
            files: files,
            user: User(userID: user?.userID ?? -1,
                       email: user?.email ?? "No email",
                       nickname: user?.nickname ?? "No nickname",
                       profileImage: user?.profileImage)
        )
    }
}
