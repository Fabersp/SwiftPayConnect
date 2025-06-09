//
//  PaymentGatewayService.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/01/25.
//

import Foundation

/// Returns a mock list of available payment gateways
class PaymentGatewayService {
    func fetchGateways() -> [Gateway] {
        return [
            Gateway(name: "Apple Pay", logoAssetName: "logo_applepay"),
            Gateway(name: "Stripe",  logoAssetName: "logo_stripe"),
            Gateway(name: "PayPal",  logoAssetName: "logo_paypal"),
            Gateway(name: "Adyen",   logoAssetName: "logo_adyen")
        ]
    }
}
