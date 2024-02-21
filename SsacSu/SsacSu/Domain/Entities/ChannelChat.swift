//
//  ChannelChat.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import Foundation

struct ChannelChat {
    let channelId: Int
    let channelName: String
    let chatId: Int
    let content: String?
    let createdAt: Date
    let files: [String]
    let user: User
}
