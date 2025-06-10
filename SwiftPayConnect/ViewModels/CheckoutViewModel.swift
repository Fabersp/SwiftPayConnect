//
//  CheckoutViewModel.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import Foundation

class CheckoutViewModel: ObservableObject {
    /// Mock data baked into the VM
    @Published var items: [CartItem] = [
        .init(name: "AirPods Pro",    price: 199.90,  quantity: 1, imageName: "airpodspro"),
        .init(name: "iPhone 16 Pro",  price: 1299.90, quantity: 1, imageName: "iphone"),
        .init(name: "Watch Series 5", price: 329.99,  quantity: 1, imageName: "applewatch")
    ]

    /// Flat shipping & handling fee
    let shippingFee: Double = 4.98

    /// Subtotal (sum of all item prices × qty)
    var subtotal: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }

    /// Grand total = subtotal + shipping
    var total: Double {
        subtotal + shippingFee
    }

    /// Increase item quantity by 1
    func increment(_ item: CartItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx].quantity += 1
    }

    /// Decrease item quantity by 1 (min 1)
    func decrement(_ item: CartItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }),
              items[idx].quantity > 1 else { return }
        items[idx].quantity -= 1
    }
}
