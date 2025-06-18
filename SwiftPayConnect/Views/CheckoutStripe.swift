//
//  CheckoutStripe.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 6/12/25.
//

import StripePaymentSheet
import SwiftUI

struct CheckoutStripe: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @ObservedObject var paymentVM: PaymentViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Item List
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.items) { item in
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
                                    viewModel.increment(item)
                                    paymentVM.updateCartCount(viewModel.items.reduce(0) { $0 + $1.quantity })
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
                                    viewModel.decrement(item)
                                    paymentVM.updateCartCount(viewModel.items.reduce(0) { $0 + $1.quantity })
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
            
            // MARK: - Summary
            VStack(spacing: 15) {
                Divider()
                summaryRow(label: "Subtotal", value: viewModel.subtotal)
                summaryRow(label: "S&H", value: viewModel.shippingFee)
                Divider()
                summaryRow(label: "TOTAL", value: viewModel.total, isTotal: true)
                Divider()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // MARK: - Stripe Payment Button
            if let stripeGateway = paymentVM.selectedGateway as? StripeGateway,
               let paymentSheet = stripeGateway.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: { result in
                        stripeGateway.paymentResult = result
                        switch result {
                        case .completed:
                            paymentVM.paymentError = nil
                            dismiss()
                        case .failed(let error):
                            paymentVM.paymentError = error.localizedDescription
                        case .canceled:
                            paymentVM.paymentError = "Payment was canceled"
                        }
                    }
                ) {
                    Text("Pay \(String(format: "$%.2f", viewModel.total))")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding(.horizontal)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if let error = paymentVM.paymentError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom)
            }
        }
        .navigationTitle("Stripe Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let stripeGateway = paymentVM.selectedGateway as? StripeGateway else { return }
            stripeGateway.processPayment(amount: viewModel.total) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        break
                    case .failure(let err):
                        paymentVM.paymentError = err.localizedDescription
                    }
                }
            }
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

