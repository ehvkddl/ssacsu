//
//  KakaoLoginRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/19.
//

import Foundation

import RxSwift

protocol KakaoLoginRepository {
    var oauthToken: PublishSubject<String> { get }
    
    func kakaoLoginWithApp()
    func kakaoLoginWithAccount()
    func performKakaoLogin()
}
