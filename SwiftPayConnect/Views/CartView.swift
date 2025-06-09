//
//  CartView.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import SwiftUI

/// Displays the shopping cart and subtotal
struct CartView: View {
    @StateObject private var viewModel = CartViewModel()

    var body: some View {
        VStack {
            List(viewModel.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("x\(item.quantity)")
                    Text(String(format: "$%.2f", item.price * Double(item.quantity)))
                }
                .padding(.vertical, 4)
            }

            Divider()

            HStack {
                Text("Subtotal")
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f", viewModel.totalAmount))
                    .font(.headline)
            }
            .padding()
        }
        .navigationTitle("Shopping Cart")
    }
}
