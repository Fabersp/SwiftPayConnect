//
//  HomeView.swift
//  PaymentIntegrations
//
//  Created by Fabricio Padua on 1/3/25.
//

import SwiftUI

/// Main menu to navigate between features
struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Add Credit Card",  destination: CardView())
                NavigationLink("View checkout",    destination: CheckoutView())
                NavigationLink("Choose Gateway",   destination: PaymentView())
            }
            .navigationTitle("SwiftPayConnect")
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
