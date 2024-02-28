//
//  UserDefault.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let value = try? JSONDecoder().decode(T.self, from: data) else {
                
                return defaultValue
            }
            
            return value
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    
    enum Key: String {
        case user
        case fcmToken
    }
    
    @UserDefault(key: Key.user.rawValue,
                 defaultValue: User(userID: -1, email: "no email", nickname: "no nickname", profileImage: nil))
    static var user
    
    @UserDefault(key: Key.fcmToken.rawValue, defaultValue: "")
    static var fcmToken
    
}
