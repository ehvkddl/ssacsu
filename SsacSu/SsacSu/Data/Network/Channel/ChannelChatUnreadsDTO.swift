//
//  ChannelChatUnreadsDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/29.
//

import Foundation

struct ChannelChatUnreadsResponseDTO: Decodable {
    let channelID: Int
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name
        case count
    }
}

extension ChannelChatUnreadsResponseDTO {
    func toDomain() -> ChannelChatUnreads {
        return .init(channelID: channelID,
                     name: name,
                     count: count)
    }
}
