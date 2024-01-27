//
//  Workspace.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/26.
//

import Foundation

struct Workspace {
    let workspaceID: Int
    let name: String
    let description: String?
    let thumbnail: String
    let ownerID: Int
    let createdAt: Date
    let channels: [Channel]?
    let workspaceMembers: [User]?
}
