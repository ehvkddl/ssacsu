//
//  AppleLoginManager.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import AuthenticationServices
import UIKit

import RxSwift

class AppleLoginRepositoryImpl: NSObject, AppleLoginRepository {
    
    var idToken = PublishSubject<String>()
    
    func performAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
}

extension AppleLoginRepositoryImpl: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - Alert으로 수정하기
        print("[didCompleteWithError]", error)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Apple Login Fail")
            return
        }
        
        let userIdentifier = appleIDCredential.user
        guard let identityToken = appleIDCredential.identityToken,
              let identityTokenToString = String(data: identityToken, encoding: .utf8) else {
            print("[Token Error]")
            return
        }
        
        UserDefaults.standard.setValue(userIdentifier, forKey: "User")
        
        idToken.on(.next(identityTokenToString))
    }

}
