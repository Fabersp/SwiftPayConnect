//
//  PaymentView.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import SwiftUI

/// Shows a list of payment gateways to choose from
struct PaymentView: View {
    @StateObject private var viewModel = PaymentViewModel()

    var body: some View {
        List(viewModel.gateways) { gateway in
            HStack {
                Image(gateway.logoAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 24)
                    .cornerRadius(4)
                Text(gateway.name)
                    .font(.headline)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Select a Gateway")
    }
}
