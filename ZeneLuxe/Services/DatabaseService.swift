//
//  DatabaseService.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation

//Local database UserDefault
class DatabaseService {
    static func saveValue(_ value: String, forKey key: String) {
        let database = UserDefaults.standard
        database.set(value, forKey: key)
        database.synchronize()
    }
    
    static func saveValue(_ array: [String], forKey key: String) {
        let database = UserDefaults.standard
        database.set(array, forKey: key)
        database.synchronize()
    }
    
    static func saveValue(_ value: Any, forKey key: String) {
        let database = UserDefaults.standard
        database.set(value, forKey: key)
        database.synchronize()
    }
    
    static func getValue(forKey key: String, defaultValue: String = "") -> String {
        let database = UserDefaults.standard
        return database.value(forKey: key) as? String ?? defaultValue
    }
    
    static func getValue(forKey key: String, defaultValue: Bool = false) -> Bool {
        let database = UserDefaults.standard
        return database.value(forKey: key) as? Bool ?? defaultValue
    }
    
    static func getValue(forKey key: String, defaultValue: [String] = []) -> [String] {
        let database = UserDefaults.standard
        return database.value(forKey: key) as? [String] ?? defaultValue
    }
    
    static func getValue(forKey key: String) -> Any? {
        let database = UserDefaults.standard
        return database.value(forKey: key)
    }
    
    static func removeObject(forKey key: String) {
        let database = UserDefaults.standard
        database.removeObject(forKey: key)
        database.synchronize()
    }
}


