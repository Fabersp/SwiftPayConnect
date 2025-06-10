//
//  PaymentViewModel.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import Combine

/// Manages the list of gateways for selection
class PaymentViewModel: ObservableObject {
    @Published var gateways: [Gateway] = []
    @Published var selectedGateway: Gateway?
    private let gatewayService = PaymentGatewayService()

    init() {
        loadGateways()
    }

    /// Load mock gateways (replace with real API call later)
    func loadGateways() {
        self.gateways = gatewayService.fetchGateways()
    }
    
    /// Select a gateway
    func selectGateway(_ gateway: Gateway) {
        selectedGateway = gateway
    }
}
