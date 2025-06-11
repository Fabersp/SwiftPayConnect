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
        request.merchantIdentifier = "merchant.com.fabricio.padua.SwiftPayConnect" // Replace with your merchant ID
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.merchantCapabilities = .capability3DS
        
        let paymentSummaryItem = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: amount))
        request.paymentSummaryItems = [paymentSummaryItem]
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController?.delegate = PaymentDelegate(completion: completion)
        paymentController?.present { presented in
            if !presented {
                completion(.failure(PaymentError.paymentFailed))
            }
        }
    }
}

// MARK: - Payment Authorization Delegate
private class PaymentDelegate: NSObject, PKPaymentAuthorizationControllerDelegate {
    private let completion: (Result<Bool, Error>) -> Void
    
    init(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.completion = completion
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Here you would typically send the payment token to your server
        // For now, we'll just simulate a successful payment
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        self.completion(.success(true))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // Handle dismissal if needed
        }
    }
} 