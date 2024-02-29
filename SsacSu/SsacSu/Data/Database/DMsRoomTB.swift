//
//  DMsRoomTB.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/29.
//

import Foundation

import RealmSwift

final class DMsRoomTB: Object {
    @Persisted(primaryKey: true) var roomID: Int
    @Persisted var workspaceID: Int
    @Persisted var createdAt: Date
    @Persisted var user: UserTB?
    
    convenience init(
        roomID: Int,
        workspaceID: Int,
        createdAt: Date,
        user: UserTB
    ) {
        self.init()
        
        self.roomID = roomID
        self.workspaceID = workspaceID
        self.createdAt = createdAt
        self.user = user
    }
}
