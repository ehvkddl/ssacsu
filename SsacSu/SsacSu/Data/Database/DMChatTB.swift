//
//  DMChatTB.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/29.
//

import Foundation

import RealmSwift

final class DMChatTB: Object {
    @Persisted(primaryKey: true) var dmID: Int
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted var room: DMsRoomTB?
    @Persisted var user: UserTB?
    
    convenience init(
        dmID: Int,
        content: String?,
        createdAt: Date,
        files: List<String>,
        room: DMsRoomTB,
        user: UserTB
    ) {
        self.init()
        
        self.dmID = dmID
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.room = room
        self.user = user
    }
}
