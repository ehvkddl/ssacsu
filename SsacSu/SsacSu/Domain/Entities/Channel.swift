//
//  Channel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import Foundation

struct Channel {
    let workspaceID: Int
    let channelID: Int
    let name: String
    let description: String?
    let ownerID: Int
    let isPrivate: Bool?
    let createdAt: Date
}
