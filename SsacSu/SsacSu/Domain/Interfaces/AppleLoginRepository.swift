//
//  AppleLoginRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/19.
//

import Foundation

import RxSwift

protocol AppleLoginRepository {
    var idToken: PublishSubject<String> { get }
    
    func performAppleLogin()
}
