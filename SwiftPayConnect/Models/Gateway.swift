//
//  Gateway.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/01/25.
//

import Foundation

/// Represents a payment gateway option
struct Gateway: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let logoAssetName: String
}
