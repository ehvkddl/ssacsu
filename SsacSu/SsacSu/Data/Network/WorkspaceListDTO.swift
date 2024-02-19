//
//  WorkspaceListDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

typealias WorkspaceList = [WorkspaceListResponseDTO]

struct WorkspaceListResponseDTO: Decodable {
    let workspaceID: Int
    let name: String
    let description: String?
    let thumbnail: String
    let ownerID: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name
        case description
        case thumbnail
        case ownerID = "owner_id"
        case createdAt
    }
}

extension WorkspaceListResponseDTO {
    func toDomain() -> Workspace {
        return .init(
            workspaceID: workspaceID,
            name: name,
            description: description,
            thumbnail: thumbnail,
            ownerID: ownerID,
            createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date(),
            channels: nil,
            workspaceMembers: nil)
    }
}
