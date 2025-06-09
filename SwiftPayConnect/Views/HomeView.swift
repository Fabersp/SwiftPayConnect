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
                NavigationLink("View Cart",         destination: CartView())
                NavigationLink("Choose Gateway",    destination: PaymentView())
            }
            .navigationTitle("SwiftPayConnect")
        }
    }
}
