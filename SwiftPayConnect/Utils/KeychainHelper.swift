
//
//  KeychainHelper.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 6/1/25.
//

import Foundation
import Security

/// Simple wrapper around Keychain Generic Password APIs
struct KeychainHelper {
    
    /// Save raw data under a given key in Keychain
    /// - Parameters:
    ///   - key: unique identifier for this item
    ///   - data: the Data blob to store
    /// - Returns: true if saved successfully
    @discardableResult
    static func save(key: String, data: Data) -> Bool {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrAccount:      key,
            kSecValueData:        data
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Load raw data from Keychain for a given key
    /// - Parameter key: unique identifier for the item
    /// - Returns: Data if found, nil otherwise
    static func load(key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrAccount:      key,
            kSecReturnData:       kCFBooleanTrue as Any,
            kSecMatchLimit:       kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }
        return data
    }
    
    /// Delete an item from Keychain
    /// - Parameter key: unique identifier for the item
    /// - Returns: true if deletion succeeded (or item didn’t exist)
    @discardableResult
    static func delete(key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
