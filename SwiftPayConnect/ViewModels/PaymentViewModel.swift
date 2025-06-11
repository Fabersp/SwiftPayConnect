//
//  PaymentViewModel.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import Combine
import SwiftUI

/// Manages the list of gateways for selection
class PaymentViewModel: ObservableObject {
    @Published var gateways: [PaymentGatewayProtocol] = []
    @Published var selectedGateway: PaymentGatewayProtocol?
    @Published var cartItemsCount: Int = 3
    @Published var isProcessingPayment = false
    @Published var paymentError: String?
    
    private let gatewayService = PaymentGatewayService()

    init() {
        loadGateways()
    }

    /// Load mock gateways (replace with real API call later)
    func loadGateways() {
        self.gateways = [
            ApplePayGateway(),
            StripeGateway(),
            PayPalGateway(),
            AdyenGateway()
        ]
    }
    
    /// Select a gateway
    func selectGateway(_ gateway: PaymentGatewayProtocol) {
        selectedGateway = gateway
    }
    
    /// Update cart items count
    func updateCartCount(_ count: Int) {
        cartItemsCount = count
    }
    
    /// Process payment with selected gateway
    func processPayment(amount: Double) {
        guard let gateway = selectedGateway else {
            paymentError = "Please select a payment gateway"
            return
        }
        
        isProcessingPayment = true
        paymentError = nil
        
        gateway.processPayment(amount: amount) { [weak self] result in
            DispatchQueue.main.async {
                self?.isProcessingPayment = false
                
                switch result {
                case .success:
                    self?.paymentError = nil
                    // Show success message or handle successful payment
                case .failure(let error):
                    self?.paymentError = error.localizedDescription
                }
            }
        }
    }
}
