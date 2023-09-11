//
//  ColumnRequiredStrengthInputView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct ColumnRequiredStrengthInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var columnRequiredStrengthModel = ColumnRequiredStrengthModel(columnRequiredStrength: ColumnRequiredStrength(Puc_1: 0.0, Vuc: 0.0, Muc_top: 0.0, Muc_bot: 0.0))
    @State private var inputString: String = ""
    
    @State private var varsValue: [Double] = [0.0, 0.0, 0.0]
    @State private var varsName: [(String, String)] = [("Pu: ", "kips"), ("Vu: ", "kips"),("Mu: ", "kip-ft")]

    var body: some View {
        ZStack {
//            Color.indigo.edgesIgnoringSafeArea(.all)
//                .opacity(0.50)
                VStack{
                    Spacer()
                VStack {
                    Text("Column Required Strength")
                    Text("LFRD")
                }
                .font(.title)
//                .foregroundColor(.white)
                .bold()
                Form{
                    VStack {
                        Text("1.  Column Axial Load    kips")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        NumericInputView(number: $varsValue[0], name: $varsName[0], placeholder_value: "Enter number")
                        Text("2.  Column Shear Load    kips")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        NumericInputView(number: $varsValue[1], name: $varsName[1], placeholder_value: "Enter number")
                        Text("3.  Column Moment Load    kip-ft")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        NumericInputView(number: $varsValue[2], name: $varsName[2], placeholder_value: "Enter number")
                        
                        Text("Warning: Empty records will\nalways be saved as   0.0 ")
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    }
                }
                    

                HStack {
                    Spacer()
                    Button {
                            
                            columnRequiredStrengthModel.columnRequiredStrength.Puc_1 = varsValue[0]
                            columnRequiredStrengthModel.columnRequiredStrength.Vuc = varsValue[1]
                            columnRequiredStrengthModel.columnRequiredStrength.Muc_top = varsValue[2]
                            columnRequiredStrengthModel.columnRequiredStrength.Muc_bot = varsValue[2]
                            columnRequiredStrengthModel.saveData()
                            print("Saved value: \(varsValue)")
                            presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save Values")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    .background(Color.blue)
                    .cornerRadius(5)
                    Spacer()
                }
            }
        }

    }
    
    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = Int.max
        return formatter.string(from: NSNumber(value: value)) ?? "N/A"
    }
}

struct ColumnRequiredStrengthInputView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnRequiredStrengthInputView()
    }
}
