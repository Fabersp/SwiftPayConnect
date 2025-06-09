//
//  CheckoutView.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 6/9/25.
//

import SwiftUI

/// Checkout screen showing items, shipping, and grand total
struct CheckoutView: View {
    @StateObject private var vm = CheckoutViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("My Cart")
                    .font(.largeTitle).bold()
                Spacer()
            }
            .padding()

            // Item list
            List(vm.items) { item in
                HStack {
                    // Placeholder thumbnail
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(String(format: "$%.2f", item.price))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("x\(item.quantity)")
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            .listStyle(PlainListStyle())

            // Summary
            VStack(spacing: 8) {
                summaryRow(label: "Subtotal", value: vm.amount)
                summaryRow(label: "S&H",       value: vm.shippingFee)
                Divider()
                summaryRow(label: "TOTAL",     value: vm.totalAmount, isTotal: true)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Checkout button
            Button(action: {
                // TODO: implement real checkout
            }) {
                Text("Checkout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }

    /// Helper to layout a summary row
    @ViewBuilder
    private func summaryRow(label: String, value: Double, isTotal: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(isTotal ? .headline : .subheadline)
                .fontWeight(isTotal ? .bold : .regular)
            Spacer()
            Text(String(format: "$%.2f", value))
                .font(isTotal ? .headline : .subheadline)
                .fontWeight(isTotal ? .bold : .regular)
        }
    }
}

// Preview
struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView()
        }
    }
}
