//
//  ChannelTB.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/22.
//

import Foundation

import RealmSwift

final class ChannelTB: Object {
    @Persisted(primaryKey: true) var channelID: Int
    @Persisted var workspaceID: Int
    @Persisted var name: String
    @Persisted var _description: String?
    @Persisted var ownerID: Int
    @Persisted var isPrivate: Int?
    @Persisted var createdAt: Date
    @Persisted var channelChats: List<ChannelChatTB>
    
    convenience init(
        channelID: Int,
        workspaceID: Int,
        name: String,
        _description: String?,
        ownerID: Int,
        isPrivate: Int?,
        createdAt: Date,
        channelChats: List<ChannelChatTB>
    ) {
        self.init()
        
        self.channelID = channelID
        self.workspaceID = workspaceID
        self.name = name
        self._description = _description
        self.ownerID = ownerID
        self.isPrivate = isPrivate
        self.createdAt = createdAt
        self.channelChats = channelChats
    }
}
