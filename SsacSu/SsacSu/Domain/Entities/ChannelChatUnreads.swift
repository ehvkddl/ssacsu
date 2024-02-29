//
//  ChannelChatUnreads.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/29.
//

import Foundation

struct ChannelChatUnreads: Decodable {
    let channelID: Int
    let name: String
    let count: Int
}
