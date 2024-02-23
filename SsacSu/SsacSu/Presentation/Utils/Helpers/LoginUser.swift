//
//  LoginUser.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import Foundation

class LoginUser {
    
    static let shared = LoginUser()
    private init () { }
    
    private let user = "LoginUser"
    
    func store(value: User) {
        guard let encoded = try? JSONEncoder().encode(value) else { return }
        
        UserDefaults.standard.setValue(encoded, forKey: user)
    }
    
    func load() -> User? {
        guard let savedData = UserDefaults.standard.object(forKey: user) as? Data else { return nil }
        guard let savedObject = try? JSONDecoder().decode(User.self, from: savedData) else { return nil }
        
        return savedObject
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: user)
    }
    
}
