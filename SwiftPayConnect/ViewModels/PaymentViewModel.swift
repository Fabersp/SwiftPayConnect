//
//  PaymentViewModel.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import Foundation
import Combine
import SwiftUI

class PaymentViewModel: ObservableObject {
    @Published var gateways: [PaymentGatewayProtocol] = []
    @Published var selectedGateway: PaymentGatewayProtocol?
    @Published var cartItems: [CartItem] = []
    @Published var cartItemsCount: Int = 3
    @Published var isProcessingPayment = false
    @Published var paymentError: String?
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private let service = PaymentGatewayService()
    private let applePayGateway = ApplePayGateway()
    private let stripeGateway = StripeGateway()
    private let paypalGateway = PayPalGateway()
    private let adyenGateway = AdyenGateway()

    init() {
        setupGateways()
    }
    
    private func setupGateways() {
        let availableGateways = service.fetchGateways()
        gateways = availableGateways.compactMap { gateway in
            switch gateway.name {
            case "Apple Pay":
                return applePayGateway
            case "Stripe":
                return stripeGateway
            case "PayPal":
                return paypalGateway
            case "Adyen":
                return adyenGateway
            default:
                return nil
            }
        }
    }

    func selectGateway(_ gateway: PaymentGatewayProtocol) {
        selectedGateway = gateway
    }

    func updateCartCount(_ count: Int) {
        cartItemsCount = count
    }
    
    func updateCartItems(_ items: [CartItem]) {
        cartItems = items
        cartItemsCount = items.reduce(0) { $0 + $1.quantity }
    }

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
                    self?.cartItems = []
                    self?.cartItemsCount = 0
                case .failure(let error):
                    self?.paymentError = error.localizedDescription
                }
            }
        }
    }
    
    func processApplePayPayment() {
        guard let applePayGateway = selectedGateway as? ApplePayGateway else {
            paymentError = "Apple Pay is not available"
            return
        }
        processPayment(amount: totalAmount)
    }
}
