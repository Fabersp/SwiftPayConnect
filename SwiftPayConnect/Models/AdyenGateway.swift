import Foundation

class AdyenGateway: PaymentGatewayProtocol {
    let name = "Adyen"
    let logoAssetName = "logo_adyen"
    
    func processPayment(amount: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Simulate Adyen payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion(.success(true))
        }
    }
} 