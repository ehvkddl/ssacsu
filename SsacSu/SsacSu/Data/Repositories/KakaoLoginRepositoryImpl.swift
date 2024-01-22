//
//  KakaoLoginRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

class KakaoLoginRepositoryImpl: KakaoLoginRepository {
    
    var oauthToken = PublishSubject<String>()
    
    func kakaoLoginWithApp() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error {
                print("[카카오톡 로그인 실패]", error)
                return
            }
            
            guard let oauthToken else {
                print("[Token Error]")
                return
            }
            
            let accessToken = oauthToken.accessToken
            
            self.oauthToken.on(.next(accessToken))
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print("[카카오 계정 로그인 실패]", error)
            }
            
            guard let oauthToken else {
                print("[Token Error]")
                return
            }
            
            let accessToken = oauthToken.accessToken
            
            self.oauthToken.on(.next(accessToken))
        }
    }
    
    func performKakaoLogin() {
        guard UserApi.isKakaoTalkLoginAvailable() else {
            kakaoLoginWithAccount()
            return
        }
        
        kakaoLoginWithApp()
    }
    
}
