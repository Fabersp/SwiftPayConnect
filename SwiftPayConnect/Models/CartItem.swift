//
//  CartItem.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import Foundation

struct CartItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Double
    var quantity: Int
    let imageName: String

    enum CodingKeys: String, CodingKey {
        case name, price, quantity, imageName
    }

    init(id: UUID = UUID(), name: String, price: Double, quantity: Int, imageName: String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.imageName = imageName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        quantity = try container.decode(Int.self, forKey: .quantity)
        imageName = try container.decode(String.self, forKey: .imageName)
        id = UUID()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(imageName, forKey: .imageName)
    }
}
