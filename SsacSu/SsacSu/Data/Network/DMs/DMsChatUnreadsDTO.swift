//
//  DMsChatUnreadsDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/29.
//

import Foundation

struct DMsChatUnreadsResponseDTO: Decodable {
    let roomID: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case count
    }
}

extension DMsChatUnreadsResponseDTO {
    func toDomain() -> DMsChatUnreads {
        return .init(roomID: roomID,
                     count: count)
    }
}
