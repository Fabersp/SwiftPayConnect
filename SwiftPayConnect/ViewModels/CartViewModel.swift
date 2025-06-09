//
//  CartViewModel.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 6/9/25.
//
import Foundation

/// Mock data for cart items
let mockCart: [CartItem] = [
    .init(name: "AirPods Pro",    price: 199.90,  quantity: 1),
    .init(name: "iPhone 16 Pro",  price: 1299.90, quantity: 1),
    .init(name: "Watch Series 5", price: 329.99,  quantity: 1)
]


import Combine

/// Manages cart items and total calculation
class CartViewModel: ObservableObject {
    /// Start with mock data
    @Published var items: [CartItem] = mockCart

    /// Compute the subtotal of all items
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}
