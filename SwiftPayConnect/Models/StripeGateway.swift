// StripeGateway.swift
import Foundation
import PassKit
import StripePaymentSheet
import SwiftUI

class StripeGateway: ObservableObject, PaymentGatewayProtocol {
    let name = "Stripe"
    let logoAssetName = "logo_stripe"

    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?

    private let endpointURL = URL(string: "https://stripe-zb0t.onrender.com/create-payment-intent")!

    func processPayment(amount: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        preparePaymentSheet(amount: amount) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sheet):
                    self?.paymentSheet = sheet
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func preparePaymentSheet(amount: Double,
                                     completion: @escaping (Result<PaymentSheet, Error>) -> Void) {
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["amount": amount])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let customerId = json["customer"] as? String,
                  let ephemeralKey = json["ephemeralKey"] as? String,
                  let paymentIntent = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String else {
                completion(.failure(StripeGatewayError.invalidResponse))
                return
            }

            STPAPIClient.shared.publishableKey = publishableKey

            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "SwiftPayConnect"
            configuration.customer = .init(id: customerId, ephemeralKeySecret: ephemeralKey)
            configuration.defaultBillingDetails = .init()
            configuration.allowsDelayedPaymentMethods = true

            var appearance = PaymentSheet.Appearance()
            appearance.cornerRadius = 8
            configuration.appearance = appearance

            if PKPaymentAuthorizationController.canMakePayments() {
                configuration.applePay = .init(
                    merchantId: "merchant.com.fabricio.padua.SwiftPayConnect",
                    merchantCountryCode: "US"
                )
            }

            let sheet = PaymentSheet(paymentIntentClientSecret: paymentIntent,
                                     configuration: configuration)
            completion(.success(sheet))
        }.resume()
    }
}

enum StripeGatewayError: Error {
    case invalidResponse
}
