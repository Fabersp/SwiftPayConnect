//
//  HomeView.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import SwiftUI

/// Main menu to navigate between features
struct HomeView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @ObservedObject var paymentVM: PaymentViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(paymentVM.gateways, id: \.name) { gateway in
                        NavigationLink(destination: destinationView(for: gateway)) {
                            VStack {
                                Image(gateway.logoAssetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .cornerRadius(8)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select a Gateway")
        }
    }
    
    @ViewBuilder
    private func destinationView(for gateway: PaymentGatewayProtocol) -> some View {
        switch gateway.name {
        case "Apple Pay":
            ApplePayCheckoutView(viewModel: viewModel, paymentVM: paymentVM)
        case "Stripe":
            StripeCheckoutView(viewModel: viewModel, paymentVM: paymentVM)
        case "PayPal":
            CheckoutView(paymentVM: paymentVM)
        case "Adyen":
            CheckoutView(paymentVM: paymentVM)
        default:
            CheckoutView(paymentVM: paymentVM)
        }
    }
}

// Adjusted Preview Setup
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: CheckoutViewModel(), paymentVM: PaymentViewModel())
                .preferredColorScheme(.light)
                .previewDevice("iPhone 14 Pro")
            
            HomeView(viewModel: CheckoutViewModel(), paymentVM: PaymentViewModel())
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 14 Pro")
        }
    }
}
