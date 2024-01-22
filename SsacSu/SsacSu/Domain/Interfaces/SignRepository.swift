//
//  SignRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/18.
//

import Foundation

import RxSwift

protocol SignRepository {
    func checkEmailValidation(email: String) -> Single<Result<Bool, SsacsuError>>
    func join(join: Join) -> Single<Result<JoinResponseDTO, SsacsuError>>
    func appleLogin(with login: AppleLogin) -> Single<Result<AppleLoginResponseDTO, SsacsuError>>
    func kakaoLogin(with login: KakaoLogin) -> Single<Result<KakaoLoginResponseDTO, SsacsuError>>
    func login(with login: Login) -> Single<Result<LoginResponseDTO, SsacsuError>>
}
