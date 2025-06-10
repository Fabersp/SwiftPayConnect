//
//  HomeView.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import SwiftUI

/// Main menu to navigate between features
struct HomeView: View {
    @StateObject private var viewModel = PaymentViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.gateways) { gateway in
                Button {
                    viewModel.selectGateway(gateway)
                } label: {
                    HStack {
                        Image(gateway.logoAssetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 24)
                            .cornerRadius(4)
                        Text(gateway.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.selectedGateway?.id == gateway.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Select a Gateway")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CheckoutView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart")
                                .font(.title3)
                            
                            if viewModel.cartItemsCount > 0 {
                                Text("\(viewModel.cartItemsCount)")
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 15, height: 15)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 5, y: -5)
                            }
                        }
                    }
                }
            }
        }
    }
}

// Adjusted Preview Setup
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .preferredColorScheme(.light)
                .previewDevice("iPhone 14 Pro")
            
            HomeView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 14 Pro")
        }
    }
}
