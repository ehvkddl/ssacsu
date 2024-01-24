//
//  AccessTokenRefreshInterceptor.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/24.
//

import Foundation

import Moya
import Alamofire

final class AccessTokenRefreshInterceptor: RequestInterceptor {
    
    var retryCount = 0
    let maximumRetryCount = 3
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let accessToken = Token.shared.load(account: .accessToken) ?? ""
        let refreshToken = Token.shared.load(account: .refreshToken) ?? ""
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "RefreshToken")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard retryCount < maximumRetryCount else {
            completion(.doNotRetry)
            return
        }
        
        guard let response = request.task?.response as? HTTPURLResponse,
                response.statusCode == 400 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        AuthManager.shared.refreshAccessToken { result in
            switch result {
            case .success:
                completion(.retry)
                
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
}
