//
//  CardView.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import SwiftUI

/// Form for entering and saving credit card details
struct CardView: View {
    @StateObject private var viewModel = CardViewModel()

    var body: some View {
        Form {
            Section(header: Text("Card Details")) {
                TextField("Card Number", text: $viewModel.number)
                    .keyboardType(.numberPad)
                TextField("MM/YY", text: $viewModel.expiry)
                    .keyboardType(.numbersAndPunctuation)
                TextField("CVC", text: $viewModel.cvc)
                    .keyboardType(.numberPad)
                TextField("Cardholder Name", text: $viewModel.holder)
            }

            Button("Save Card") {
                viewModel.saveCard()
            }
            .disabled(
                viewModel.number.isEmpty ||
                viewModel.expiry.isEmpty ||
                viewModel.cvc.isEmpty ||
                viewModel.holder.isEmpty
            )

            if viewModel.isSaved {
                Text("Card saved ✅")
                    .foregroundColor(.green)
            }
        }
        .navigationTitle("Add Credit Card")
    }
}
