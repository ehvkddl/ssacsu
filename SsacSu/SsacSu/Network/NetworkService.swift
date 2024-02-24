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
    case sign(SignAPI)
    case user(UserAPI)
    case workspace(WorkspaceAPI)
    case channel(ChannelAPI)
}

protocol NetworkService {
    func processResponse<U: Decodable>(api: API, responseType: U.Type, completion: @escaping (Result<U, SsacsuError>) -> Void)
    func processResponse<U: Decodable>(api: API, responseType: U.Type?) -> Single<Result<U, SsacsuError>>
}

class NetworkServiceImpl: NetworkService {
    let signProvider: MoyaProvider<SignAPI>
    let userProvider: MoyaProvider<UserAPI>
    let workspaceProvider: MoyaProvider<WorkspaceAPI>
    let channelProvider: MoyaProvider<ChannelAPI>

    init(signProvider: MoyaProvider<SignAPI>,
         userProvider: MoyaProvider<UserAPI>,
         workspaceProvider: MoyaProvider<WorkspaceAPI>,
         channelProvider: MoyaProvider<ChannelAPI>
    ) {
        self.signProvider = signProvider
        self.userProvider = userProvider
        self.workspaceProvider = workspaceProvider
        self.channelProvider = channelProvider
    }
}

extension NetworkServiceImpl {

    func processResponse<U: Decodable>(
        api: API,
        responseType: U.Type,
        completion: @escaping (Result<U, SsacsuError>) -> Void
    ) {
        switch api {
        case .sign(let signAPI):
            request(signAPI, responseType: responseType, completion: completion)
        case .user(let userAPI):
            request(userAPI, responseType: responseType, completion: completion)
        case .workspace(let workspaceAPI):
            request(workspaceAPI, responseType: responseType, completion: completion)
        case .channel(let channelAPI):
            request(channelAPI, responseType: responseType, completion: completion)
        }
    }

    private func request<U: Decodable, T: TargetType>(
        _ target: T,
        responseType: U.Type,
        completion: @escaping (Result<U, SsacsuError>) -> Void
    ) {
        
        let provider: MoyaProvider<T> = getProvider(for: target)
        
        provider.request(target) { result in
            print("야아ㅏ아아아아ㅏ아아아아ㅏ앙ㄱ!!!!!!!!!!!!!!", result)
            
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
                        return completion(.failure(error))
                    case .failure:
                        return completion(.failure(.decodingFailure))
                    }
                }
                
                let decodedResult = ResponseDecoder.decode(responseType, data: response.data)
                print("디코딩 완", decodedResult)
                
                switch decodedResult {
                case .success(let decodedData):
                    print("디코딩 성공 싱글.썩세스.썩세스")
                    completion(.success(decodedData))
                    
                case .failure:
                    completion(.failure(.decodingFailure))
                }
                
            case .failure(let error):
                print("왜 이 오류가 낫나여", error)
                completion(.failure(.serverError))
            }
        }
    }
    
    func processResponse<U: Decodable>(
        api: API,
        responseType: U.Type?
    ) -> Single<Result<U, SsacsuError>> {
        return Single<Result<U, SsacsuError>>.create { single in
            switch api {
            case .sign(let signAPI):
                self.request(signAPI, single: single, responseType: responseType)
            case .user(let userAPI):
                self.request(userAPI, single: single, responseType: responseType)
            case .workspace(let workspaceAPI):
                self.request(workspaceAPI, single: single, responseType: responseType)
            case .channel(let channelAPI):
                self.request(channelAPI, single: single, responseType: responseType)
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
        case is SignAPI:
            return signProvider as! MoyaProvider<T>
        case is UserAPI:
            return userProvider as! MoyaProvider<T>
        case is WorkspaceAPI:
            return workspaceProvider as! MoyaProvider<T>
        case is ChannelAPI:
            return channelProvider as! MoyaProvider<T>
        default:
            fatalError("Unsupported type")
        }
    }
    
}
