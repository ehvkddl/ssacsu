//
//  NetworkService.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import Foundation

import RxSwift
import Moya

protocol NetworkService {
    func processResponse<T: Decodable>(api: SsacsuAPI, responseType: T.Type?) -> Single<Result<T, SsacsuError>>
    func decode<U: Decodable>(_ type: U.Type, data: Data) -> Result<U, Error>
}

class NetworkServiceImpl<T: TargetType>: NetworkService {
    let provider: MoyaProvider<T>
    
    init(provider: MoyaProvider<T>) {
        self.provider = provider
    }
}

extension NetworkServiceImpl {
    
    func processResponse<U: Decodable>(api: SsacsuAPI, responseType: U.Type?) -> Single<Result<U, SsacsuError>> {
        return Single<Result<U, SsacsuError>>.create { single in
            self.provider.request(api as! T) { result in
                switch result {
                case .success(let response):
                    guard 200...299 ~= response.statusCode else {
                        let errorResponse = self.decode(CommonErrorResponseDTO.self, data: response.data)
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
                    
                    let decodedResult = self.decode(responseType, data: response.data)
                    print(decodedResult)
                    
                    switch decodedResult {
                    case .success(let decodedData):
                        return single(.success(.success(decodedData)))
                        
                    case .failure:
                        return single(.failure(SsacsuError.decodingFailure))
                    }
                case .failure(let error):
                    print(error)
                    return single(.failure(SsacsuError.serverError))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func decode<U: Decodable>(_ type: U.Type, data: Data) -> Result<U, Error> {
        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
}
