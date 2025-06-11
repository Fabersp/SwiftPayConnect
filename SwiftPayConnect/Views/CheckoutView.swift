//
//  CheckoutView.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var vm = CheckoutViewModel()
    @ObservedObject var paymentVM: PaymentViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 10) {
            // MARK: – Item List
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(vm.items) { item in
                        HStack(spacing: 16) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline).bold()
                                Text(String(format: "$%.2f", item.price))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            // Quantity controls
                            VStack(spacing: 8) {
                                Button { 
                                    vm.increment(item)
                                    paymentVM.updateCartCount(vm.items.reduce(0) { $0 + $1.quantity })
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(6)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                                Text("\(item.quantity)")
                                    .font(.headline)
                                Button { 
                                    vm.decrement(item)
                                    paymentVM.updateCartCount(vm.items.reduce(0) { $0 + $1.quantity })
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(6)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
            }

            // MARK: – Summary
            VStack(spacing: 15) {
                Divider()
                summaryRow(label: "Subtotal", value: vm.subtotal)
                summaryRow(label: "S&H",       value: vm.shippingFee)
                Divider()
                summaryRow(label: "TOTAL",     value: vm.total, isTotal: true)
                Divider()
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // MARK: – Checkout button
            Button {
                paymentVM.processPayment(amount: vm.total)
            } label: {
                if paymentVM.isProcessingPayment {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Checkout")
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(25)
            .padding(.horizontal)
            .padding(.bottom, 15)
            .disabled(paymentVM.isProcessingPayment)
            
            if let error = paymentVM.paymentError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom)
            }
        }
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Update cart count when view appears
            paymentVM.updateCartCount(vm.items.reduce(0) { $0 + $1.quantity })
        }
    }

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

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { CheckoutView(paymentVM: PaymentViewModel()) }
    }
}
