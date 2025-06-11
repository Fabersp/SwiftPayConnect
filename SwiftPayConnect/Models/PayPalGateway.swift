import Foundation

class PayPalGateway: PaymentGatewayProtocol {
    let name = "PayPal"
    let logoAssetName = "logo_paypal"
    
    func processPayment(amount: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Simulate PayPal payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion(.success(true))
        }
    }
} 