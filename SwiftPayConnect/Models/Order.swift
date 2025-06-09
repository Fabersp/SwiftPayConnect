//
//  Order.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import Foundation

struct OrderResponse: Codable {
    let order: Order
}

struct Order: Codable {
    let items: [CartItem]
    let amount: Double
    let shippingFee: Double
    let totalAmount: Double
}
