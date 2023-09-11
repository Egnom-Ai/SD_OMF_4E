//
//  ColumnRequiredStrengthView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

// ColumnRequiredStrength
struct ColumnRequiredStrength: Identifiable, Codable {
    var id: UUID = UUID()
    var Puc_1: Double
    var Vuc: Double
    var Muc_top: Double
    var Muc_bot: Double

    var Puc_1String: String {
        get {
            let formatter = NumberFormatter()
            formatter.groupingSeparator = ","
            formatter.decimalSeparator = "."
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: Puc_1)) ?? ""
        }
        set {
            let formatter = NumberFormatter()
            formatter.groupingSeparator = ","
            formatter.decimalSeparator = "."
            if let number = formatter.number(from: newValue)?.doubleValue {
                Puc_1 = number
            }
        }
    }
}
