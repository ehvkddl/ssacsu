//
//  NetworkService.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import Foundation

import RxSwift
import Moya

enum API {
    case user(UserAPI)
    case workspace(WorkspaceAPI)
}

protocol NetworkService {
    func processResponse<U: Decodable>(api: API, responseType: U.Type?) -> Single<Result<U, SsacsuError>>
}

class NetworkServiceImpl: NetworkService {
    let userProvider: MoyaProvider<UserAPI>
    let workspaceProvider: MoyaProvider<WorkspaceAPI>

    init(userProvider: MoyaProvider<UserAPI>,
         workspaceProvider: MoyaProvider<WorkspaceAPI>
    ) {
        self.userProvider = userProvider
        self.workspaceProvider = workspaceProvider
    }
}

extension NetworkServiceImpl {

    func processResponse<U: Decodable>(
        api: API,
        responseType: U.Type?
    ) -> Single<Result<U, SsacsuError>> {
        return Single<Result<U, SsacsuError>>.create { single in
            switch api {
            case .user(let userAPI):
                self.request(userAPI, single: single, responseType: responseType)
            case .workspace(let workspaceAPI):
                self.request(workspaceAPI, single: single, responseType: responseType)
            }
            
            return Disposables.create()
        }
    }
    
    private func request<U: Decodable, T: TargetType>(
        _ target: T,
        single: @escaping (SingleEvent<Result<U, SsacsuError>>) -> Void,
        responseType: U.Type?
    ) {
        let provider: MoyaProvider<T> = getProvider(for: target)

        provider.request(target) { result in
            switch result {
            case .success(let response):
                guard 200...299 ~= response.statusCode else {
                    let errorResponse = ResponseDecoder.decode(CommonErrorResponseDTO.self, data: response.data)
                    print("[CommonError]", errorResponse)
                    
                    switch errorResponse {
                    case .success(let response):
                        guard let error = SsacsuError(rawValue: response.errorCode) else {
                            print("Error code not found")
                            return
                        }
                        
                        
                        return single(.success(.failure(error)))
                    case .failure:
                        return single(.failure(SsacsuError.decodingFailure))
                    }
                }
                
                guard let responseType else { return single(.success(.success(true as! U))) }
                
                let decodedResult = ResponseDecoder.decode(responseType, data: response.data)
                print(decodedResult)
                
                switch decodedResult {
                case .success(let decodedData):
                    return single(.success(.success(decodedData)))
                    
                case .failure:
                    return single(.failure(SsacsuError.decodingFailure))
                }
            case .failure(let error):
                return single(.failure(SsacsuError.serverError))
            }
        }
    }

    private func getProvider<T: TargetType>(for target: T) -> MoyaProvider<T> {
        switch target {
        case is UserAPI:
            return userProvider as! MoyaProvider<T>
        case is WorkspaceAPI:
            return workspaceProvider as! MoyaProvider<T>
        default:
            fatalError("Unsupported type")
        }
    }
    
}
