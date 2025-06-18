// PaymentGatewayProtocol.swift
import Foundation

protocol PaymentGatewayProtocol {
    var name: String { get }
    var logoAssetName: String { get }
    func processPayment(amount: Double, completion: @escaping (Result<Bool, Error>) -> Void)
}

enum PaymentError: Error {
    case gatewayNotAvailable
    case paymentFailed
    case invalidAmount
    case userCancelled
}
