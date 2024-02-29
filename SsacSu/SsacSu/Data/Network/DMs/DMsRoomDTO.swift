//
//  DMsRoomDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

struct DMsRoomResponseDTO: Decodable {
    let workspaceID: Int
    let roomID: Int
    let createdAt: String
    let user: UserResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case createdAt
        case user
    }
}

extension DMsRoomResponseDTO {
    func toDomain() -> DMsRoom {
        return .init(workspaceID: workspaceID,
                     roomID: roomID,
                     createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date(),
                     user: user.toDomain())
    }
}
