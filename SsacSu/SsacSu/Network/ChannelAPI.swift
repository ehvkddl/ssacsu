//
//  ChattingAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/22.
//

import Foundation

import Moya

enum ChannelAPI {
    case fetchChats(workspaceID: Int, channelName: String, date: String)
}

extension ChannelAPI: BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchChats(let id, let name, _): return "v1/workspaces/\(id)/channels/\(name)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchChats: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchChats(_, _, let date):
            return .requestParameters(parameters: ["cursor_date": date], encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchChats:
            [
                "Content-Type": "application/json",
                "SesacKey": Configurations.SeSACKey
            ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
