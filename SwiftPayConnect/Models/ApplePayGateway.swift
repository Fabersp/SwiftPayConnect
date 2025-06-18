// ApplePayGateway.swift
import Foundation
import PassKit

class ApplePayGateway: PaymentGatewayProtocol {
    let name = "Apple Pay"
    let logoAssetName = "logo_applepay"

    private var paymentController: PKPaymentAuthorizationController?

    func processPayment(amount: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            completion(.failure(PaymentError.gatewayNotAvailable))
            return
        }

        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.fabricio.padua.SwiftPayConnect"
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.supportedNetworks = [.visa, .masterCard, .amex, .discover]
        request.merchantCapabilities = .capability3DS

        let summary = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: amount))
        request.paymentSummaryItems = [summary]

        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController?.delegate = PaymentDelegate(completion: completion)
        paymentController?.present { presented in
            if !presented {
                completion(.failure(PaymentError.paymentFailed))
            }
        }
    }
}

private class PaymentDelegate: NSObject, PKPaymentAuthorizationControllerDelegate {
    private let completion: (Result<Bool, Error>) -> Void

    init(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.completion = completion
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        handler handlerCompletion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        handlerCompletion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        completion(.success(true))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
    }
}
