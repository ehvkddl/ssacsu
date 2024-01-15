//
//  Configurations.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/05.
//

import Foundation

enum Configurations {
    
    static let SeSACKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SeSAC_KEY") as? String else {
            fatalError("SeSACKey must not be empty in plist")
        }
        return key
    }()
    
    static let KakaoKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
            fatalError("KakaoKey must not be empty in plist")
        }
        return key
    }()
    
    static let baseURL: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("baseURL must not be empty in plist")
        }
        return key
    }()
    
}
