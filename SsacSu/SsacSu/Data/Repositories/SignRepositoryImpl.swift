//
//  DefaultSignRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import Foundation

import RxSwift

final class SignRepositoryImpl {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension SignRepositoryImpl: SignRepository {
    
    func checkEmailValidation(email: String) -> Single<Result<Bool, SsacsuError>> {
        let request = EmailValidationRequestDTO(email: email)
        
        return networkService.processResponse(
            api: .sign(SignAPI.checkEmailValidation(email: request)),
            responseType: nil
        )
    }
    
    func join(join: Join) -> Single<Result<JoinResponseDTO, SsacsuError>> {
        let request = join.toRequest()
        
        return networkService.processResponse(
            api: .sign(SignAPI.join(join: request)),
            responseType: JoinResponseDTO.self
        )
    }
    
    func appleLogin(with login: AppleLogin) -> Single<Result<AppleLoginResponseDTO, SsacsuError>> {
        let request = login.toRequest()
        
        return networkService.processResponse(
            api: .sign(SignAPI.appleLogin(login: request)),
            responseType: AppleLoginResponseDTO.self
        )
    }
    
    func kakaoLogin(with login: KakaoLogin) -> Single<Result<KakaoLoginResponseDTO, SsacsuError>> {
        let request = login.toRequest()
        
        return networkService.processResponse(
            api: .sign(SignAPI.kakaoLogin(login: request)),
            responseType: KakaoLoginResponseDTO.self
        )
    }
    
    func login(with login: EmailLogin) -> Single<Result<LoginResponseDTO, SsacsuError>> {
        let request = login.toRequest()
        
        return networkService.processResponse(
            api: .sign(SignAPI.login(login: request)),
            responseType: LoginResponseDTO.self
        )
    }
    
}
