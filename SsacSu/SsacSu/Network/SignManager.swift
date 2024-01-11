//
//  SignManager.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/10.
//

import Foundation

import Moya
import RxSwift

class SignManager {
    
    static let shared = SignManager()
    private init() { }
    
    let provider = MoyaProvider<SsacsuAPI>()
    
    func checkEmailValidation(email: String) -> Single<Bool> {
        let request = EmailValidationRequestDTO(email: email)
        
        return Single<Bool>.create { single in
            self.provider.request(SsacsuAPI.checkEmailValidation(email: request)) { result in
                switch result {
                case .success(let response):
                    guard 200...299 ~= response.statusCode else {
                        let decodeResult = self.decode(CommonErrorResponseDTO.self, data: response.data)
                        print(decodeResult)
                        return
                    }
                    
                    return single(.success(true))
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
}
