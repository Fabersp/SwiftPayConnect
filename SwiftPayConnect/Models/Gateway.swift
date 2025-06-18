//
//  Gateway.swift
//  SwiftPayConnect
//
//  Created by Fabricio Padua on 06/01/25.
//

import Foundation

struct Gateway: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let logoAssetName: String
}
