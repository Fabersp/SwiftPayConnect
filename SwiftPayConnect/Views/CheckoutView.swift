//
//  CheckoutView.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/09/25.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var vm = CheckoutViewModel()

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    /* go back */
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // MARK: – Title
            HStack {
                Text("My Cart")
                    .font(.title).bold()
                Spacer()
            }
            .padding(.horizontal)

            // MARK: – Item List
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(vm.items) { item in
                        HStack(spacing: 16) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline).bold()
                                Text(String(format: "$%.2f", item.price))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            // Quantity controls
                            VStack(spacing: 8) {
                                Button { vm.increment(item) } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(6)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                                Text("\(item.quantity)")
                                    .font(.headline)
                                Button { vm.decrement(item) } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(6)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        
                        .padding(.horizontal)
                        
                    }
                }
                .padding(.top, 8)
            }

            // MARK: – Summary
            VStack(spacing: 15) {
                Divider()
                summaryRow(label: "Subtotal", value: vm.subtotal)
                summaryRow(label: "S&H",       value: vm.shippingFee)
                Divider()
                summaryRow(label: "TOTAL",     value: vm.total, isTotal: true)
                Divider()
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // MARK: – Checkout button
            Button {
                // TODO: implement checkout action
            } label: {
                Text("Checkout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func summaryRow(label: String, value: Double, isTotal: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(isTotal ? .headline : .subheadline)
                .fontWeight(isTotal ? .bold : .regular)
            Spacer()
            Text(String(format: "$%.2f", value))
                .font(isTotal ? .headline : .subheadline)
                .fontWeight(isTotal ? .bold : .regular)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { CheckoutView() }
    }
}
