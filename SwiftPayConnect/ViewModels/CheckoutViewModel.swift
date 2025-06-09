//
//  CheckoutViewModel.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 6/9/25.
//

import Foundation

class CheckoutViewModel: ObservableObject {
    @Published var items:       [CartItem] = []
    @Published var amount:      Double     = 0
    @Published var shippingFee: Double     = 0
    @Published var totalAmount: Double     = 0

    init() {
        loadMockOrder()
    }

    private func loadMockOrder() {
        guard let url      = Bundle.main.url(forResource: "MockOrder", withExtension: "json"),
              let data     = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(OrderResponse.self, from: data) else {
            return
        }
        self.items       = response.order.items
        self.amount      = response.order.amount
        self.shippingFee = response.order.shippingFee
        self.totalAmount = response.order.totalAmount
    }
}
