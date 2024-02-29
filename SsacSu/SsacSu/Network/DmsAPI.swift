//
//  DmsAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

import Moya

enum DmsAPI {
    case fetchDMsRoom(workspaceID: Int)
    case fetchUnreadDM(workspaceID: Int, roomID: Int, date: String)
}

extension DmsAPI: BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchDMsRoom(let workspaceID): return "v1/workspaces/\(workspaceID)/dms"
        case .fetchUnreadDM(let workspaceID, let roomID, _): return "v1/workspaces/\(workspaceID)/dms/\(roomID)/unreads"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDMsRoom, .fetchUnreadDM: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchDMsRoom: return .requestPlain
        case .fetchUnreadDM(_, _, let date):
            return .requestParameters(parameters: ["after": date], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchDMsRoom, .fetchUnreadDM:
            [
                "Content-Type": "application/json",
                "SesacKey": Configurations.SeSACKey
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
