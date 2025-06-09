//
//  CardViewModel.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import Combine
import Foundation

/// Handles card data entry and secure storage
class CardViewModel: ObservableObject {
    @Published var number  = ""
    @Published var expiry  = ""
    @Published var cvc     = ""
    @Published var holder  = ""
    @Published var isSaved = false

    /// Store the card in the keychain
    func saveCard() {
        let card = Card(number: number, expiry: expiry, cvc: cvc, holder: holder)
        if let data = try? JSONEncoder().encode(card) {
            KeychainHelper.save(key: "saved_credit_card", data: data)
            isSaved = true
        }
    }
}
