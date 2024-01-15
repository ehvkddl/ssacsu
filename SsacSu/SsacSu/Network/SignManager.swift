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
    
    func join(join: Join) -> Single<JoinResponseDTO> {
        let request = join.toRequest()
        
        return Single<JoinResponseDTO>.create { single in
            self.provider.request(SsacsuAPI.join(join: request)) { result in
                switch result {
                case .success(let response):
                    guard 200...299 ~= response.statusCode else {
                        let decodedResult = self.decode(CommonErrorResponseDTO.self, data: response.data)
                        print(decodedResult)
                        return
                    }
                    
                    let decodedResult = self.decode(JoinResponseDTO.self, data: response.data)
                    print(decodedResult)
                    
                    switch decodedResult {
                    case .success(let success):
                        return single(.success(success))
                        
                    case .failure(let failure):
                        return single(.failure(failure))
                    }
                case .failure(let error):
                    print(error)
                    return single(.failure(error))
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func appleLogin(with login: AppleLogin) -> Single<AppleLoginResponseDTO> {
        let request = login.toRequest()
        
        return Single<AppleLoginResponseDTO>.create { single in
            self.provider.request(SsacsuAPI.appleLogin(login: request)) { result in
                switch result {
                case .success(let response):
                    guard 200...299 ~= response.statusCode else {
                        let decodedResult = self.decode(CommonErrorResponseDTO.self, data: response.data)
                        print(decodedResult)
                        return
                    }
                    
                    let decodedResult = self.decode(AppleLoginResponseDTO.self, data: response.data)
                    print(decodedResult)
                    
                    switch decodedResult {
                    case .success(let success):
                        print(success)
                        return single(.success(success))
                        
                    case .failure(let failure):
                        print(failure)
                        return single(.failure(failure))
                    }
                case .failure(let error):
                    print(error)
                    return single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func login(with login: Login) -> Single<LoginResponseDTO> {
        let request = login.toRequest()
        
        return Single<LoginResponseDTO>.create { single in
            self.provider.request(SsacsuAPI.login(login: request)) { result in
                switch result {
                case .success(let response):
                    guard 200...299 ~= response.statusCode else {
                        let decodedResult = self.decode(CommonErrorResponseDTO.self, data: response.data)
                        print(decodedResult)
                        return
                    }
                    
                    let decodedResult = self.decode(LoginResponseDTO.self, data: response.data)
                    
                    switch decodedResult {
                    case .success(let success):
                        return single(.success(success))
                        
                    case .failure(let failure):
                        return single(.failure(failure))
                    }
                case .failure(let error):
                    print(error)
                    return single(.failure(error))
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
