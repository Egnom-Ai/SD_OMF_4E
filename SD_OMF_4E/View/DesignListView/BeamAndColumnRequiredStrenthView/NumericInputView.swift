//
//  NumericInputView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct NumericInputView: View {
    @Binding var number: Double
    @Binding var name:  (String, String)
    @State private var inputString_value: String = ""
    
    var placeholder_value: String = "Enter number"

    var body: some View {
        HStack {
            Text(name.0)
                .bold()

            TextField(placeholder_value, text: $inputString_value)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .font(.body)
                .foregroundColor(.blue)
                
                .onChange(of: inputString_value, perform: { value in
                    formatInput()
                })
            Text(name.1)
                .bold()
        }
    }
    
    func formatInput() {
        let strippedValue = inputString_value.replacingOccurrences(of: ",", with: "")
        var components = strippedValue.components(separatedBy: ".")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        
        if let intValue = Int(components[0]) {
            components[0] = formatter.string(from: NSNumber(value: intValue)) ?? ""
        }
        
        // Remove any extra decimal points
        if components.count > 2 {
            let decimalPart = components[1..<components.count].joined()
            components = [components[0], decimalPart]
        }
        
        inputString_value = components.joined(separator: ".")
        
        if let doubleValue = Double(inputString_value.replacingOccurrences(of: ",", with: "")) {
            number = doubleValue
        }
    }
}

//struct NumericInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        NumericInputView()
//    }
//}
