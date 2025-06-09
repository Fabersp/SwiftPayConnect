//
//  Card.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 1/3/25.
//

import Foundation

/// Represents a credit card stored securely
struct Card: Codable, Identifiable {
    /// Unique identifier for each card
    let id: UUID
    
    /// Card number (e.g. “4242 4242 4242 4242”)
    let number: String
    
    /// Expiration date in MM/YY format
    let expiry: String
    
    /// Card security code
    let cvc: String
    
    /// Cardholder’s full name
    let holder: String
    
    /// Default initializer, auto-generates `id`
    init(id: UUID = UUID(),
         number: String,
         expiry: String,
         cvc: String,
         holder: String) {
        self.id = id
        self.number = number
        self.expiry = expiry
        self.cvc = cvc
        self.holder = holder
    }
}
