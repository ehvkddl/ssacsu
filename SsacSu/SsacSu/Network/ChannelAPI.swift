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
    case createChat(workspaceID: Int, channelName: String, chat: ChannelChatRequestDTO)
}

extension ChannelAPI: BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchChats(let id, let name, _): return "v1/workspaces/\(id)/channels/\(name)/chats"
        case .createChat(let id, let name, _): return "v1/workspaces/\(id)/channels/\(name)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchChats: return .get
        case .createChat: return .post
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        switch self {
        case .createChat(_, _, let chat):
            var multipartFormData: [MultipartFormData] = []
            
            let content = {
                guard let content = chat.content else { return "" }
                return content
            }()
            
            if let contentData = content.data(using: .utf8) {
                let contentFormData = MultipartFormData(provider: .data(contentData), name: "content")
                
                multipartFormData.append(contentFormData)
            }
            
            if let files = chat.files {
                files.enumerated().forEach { idx, file in
                    let fileData = MultipartFormData(provider: .data(file), name: "files", fileName: "image.png", mimeType: "image/png")
                    
                    multipartFormData.append(fileData)
                }
            }
            
            return multipartFormData
            
        default:
            return nil
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchChats(_, _, let date):
            return .requestParameters(parameters: ["cursor_date": date], encoding: URLEncoding.queryString)
        
        case .createChat:
            guard let multipartBody else { return .uploadMultipart([]) }
            
            return .uploadMultipart(multipartBody)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchChats:
            [
                "Content-Type": "application/json",
                "SesacKey": Configurations.SeSACKey
            ]
        case .createChat:
            [
                "Content-Type": "multipart/form-data",
                "SesacKey": Configurations.SeSACKey
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
