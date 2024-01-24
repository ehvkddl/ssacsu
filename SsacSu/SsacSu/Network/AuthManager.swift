//
//  AuthAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/24.
//

import Foundation

import Moya

enum AuthAPI {
    case refresh
}

extension AuthAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .refresh: return "v1/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refresh: .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .refresh:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let accessToken = Token.shared.load(account: .accessToken) ?? ""
        let refreshToken = Token.shared.load(account: .refreshToken) ?? ""
        
        return [
            "Content-Type": "application/json",
            "Authorization": accessToken,
            "RefreshToken": refreshToken,
            "SesacKey": Configurations.SeSACKey
        ]
    }
    
}

class AuthManager {
    
    static let shared = AuthManager()
    private init() { }
    
    let provider = MoyaProvider<AuthAPI>()
    
    func refreshAccessToken(completion: @escaping (Result<Void, SsacsuError>) -> Void) {
        provider.request(AuthAPI.refresh) { result in
            switch result {
            case .success(let response):
                guard 200...299 ~= response.statusCode else {
                    let errorResponse = ResponseDecoder.decode(CommonErrorResponseDTO.self, data: response.data)
                    switch errorResponse {
                    case .success(let response):
                        guard let error = SsacsuError(rawValue: response.errorCode) else {
                            return
                        }
                        return
                        
                    case .failure:
                        return
                    }
                }
                
                let decodedData = ResponseDecoder.decode(TokenRefreshDTO.self, data: response.data)

                switch decodedData {
                case .success(let success):
                    let accessToken = success.accessToken
                    Token.shared.save(account: .accessToken, value: accessToken)
                    
                    completion(.success(()))
                    
                case .failure(let failure):
                    completion(.failure(SsacsuError.decodingFailure))
                }
                
            case .failure(let error):
                completion(.failure(SsacsuError.serverError))
            }
        }
    }
    
}
