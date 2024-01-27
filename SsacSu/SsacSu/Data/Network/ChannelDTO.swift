//
//  ChannelDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import Foundation

struct ChannelResponseDTO: Decodable {
    let workspaceID: Int
    let channelID: Int
    let name: String
    let description: String?
    let ownerID: Int
    let isPrivate: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name
        case description
        case ownerID = "owner_id"
        case isPrivate = "private"
        case createdAt
    }
}
