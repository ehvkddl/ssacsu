//
//  ChannelChatDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import Foundation

struct ChannelChatResponseDTO: Decodable {
    let channelId: Int
    let channelName: String
    let chatId: Int
    let content: String?
    let createdAt: String
    let files: [String]
    let user: UserResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelName
        case chatId = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
}

extension ChannelChatResponseDTO {
    func toDomain() -> ChannelChat {
        return .init(channelId: channelId,
                     channelName: channelName,
                     chatId: chatId,
                     content: content,
                     createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date(),
                     files: files,
                     user: user.toDomain())
    }
}
