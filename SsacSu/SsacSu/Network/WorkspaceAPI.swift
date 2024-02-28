//
//  WorkspaceAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation

import Moya

enum WorkspaceAPI {
    case fetchWorkspace
    case fetchSingleWorkspace(id: Int)
}

extension WorkspaceAPI: BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchWorkspace: return "v1/workspaces"
        case .fetchSingleWorkspace(let id): return "v1/workspaces/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWorkspace, .fetchSingleWorkspace: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchWorkspace, .fetchSingleWorkspace:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
