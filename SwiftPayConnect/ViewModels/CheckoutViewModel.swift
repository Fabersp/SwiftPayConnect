//
//  CheckoutViewModel.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import Foundation
import SwiftUI

class CheckoutViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    let shippingFee: Double = 4.98
    
    weak var paymentVM: PaymentViewModel?

    var subtotal: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }

    var total: Double {
        subtotal + shippingFee
    }

    init(paymentVM: PaymentViewModel? = nil) {
        self.paymentVM = paymentVM
        // Initialize mock items or load from data source
        items = [
            CartItem(name: "AirPods Pro", price: 199.90, quantity: 1, imageName: "airpodspro"),
            CartItem(name: "iPhone 16 Pro", price: 1299.90, quantity: 1, imageName: "iphone"),
            CartItem(name: "Watch Series 5", price: 329.99, quantity: 1, imageName: "applewatch")
        ]
        updatePaymentViewModel()
    }

    func increment(_ item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity += 1
        updatePaymentViewModel()
    }

    func decrement(_ item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }),
              items[index].quantity > 1 else { return }
        items[index].quantity -= 1
        updatePaymentViewModel()
    }
    
    private func updatePaymentViewModel() {
        paymentVM?.updateCartItems(items)
    }
}
