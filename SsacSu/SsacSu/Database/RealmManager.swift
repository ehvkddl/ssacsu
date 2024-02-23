//  RealmManager.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/21.
//

import Foundation
import RealmSwift

protocol RealmManager {
}

final class RealmManagerImpl: RealmManager {
    
    private let realm: Realm? = {
        do {
            print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
            return try Realm()
        } catch {
            print("Failed to Realm load")
            
            return nil
        }
    }()

    
}
