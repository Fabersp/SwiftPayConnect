import Foundation

class StripeGateway: PaymentGatewayProtocol {
    let name = "Stripe"
    let logoAssetName = "logo_stripe"
    
    func processPayment(amount: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Simulate Stripe payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion(.success(true))
        }
    }
} 