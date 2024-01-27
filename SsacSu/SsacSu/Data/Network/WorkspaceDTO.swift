//
//  WorkspaceDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/27.
//

import Foundation

struct WorkspaceResponseDTO: Decodable {
    let workspaceID: Int
    let name: String
    let description: String?
    let thumbnail: String
    let ownerID: Int
    let createdAt: String
    let channels: [ChannelResponseDTO]?
    let workspaceMembers: [UserResponseDTO]?
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name
        case description
        case thumbnail
        case ownerID = "owner_id"
        case createdAt
        case channels
        case workspaceMembers
    }
}
