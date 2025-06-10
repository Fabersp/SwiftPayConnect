//
//  CartItem.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import Foundation

/// Represents a single item in the shopping cart
struct CartItem: Identifiable, Codable {
    /// We generate a fresh UUID for each decoded item
    var id: UUID
    let name: String
    let price: Double
    var quantity: Int
    let imageName: String

    // Only these keys are in the JSON
    enum CodingKeys: String, CodingKey {
        case name, price, quantity, imageName
    }

    /// Default initializer for mock data
    init(id: UUID = UUID(),
         name: String,
         price: Double,
         quantity: Int,
         imageName: String) {
        self.id       = id
        self.name     = name
        self.price    = price
        self.quantity = quantity
        self.imageName = imageName
        
    }

    /// Custom decoder: read name, price and quantity, then generate an id
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.name     = try c.decode(String.self,  forKey: .name)
        self.price    = try c.decode(Double.self,  forKey: .price)
        self.quantity = try c.decode(Int.self,     forKey: .quantity)
        self.imageName = try c.decode(String.self,  forKey: .imageName)
        self.id       = UUID()
    }

    /// Only encode the three JSON fields (we don’t write `id` back out)
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name,     forKey: .name)
        try c.encode(price,    forKey: .price)
        try c.encode(quantity, forKey: .quantity)
        try c.encode(imageName, forKey: .imageName)
    }
}
