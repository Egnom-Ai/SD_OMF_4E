//
//  ColumnHeightInputView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct ColumnHeightInputView: View {

        @Environment(\.presentationMode) var presentationMode
        @StateObject private var columnPropertiesDetailModel = ColumnPropertiesDetailModel(columnPropertiesDetails: ColumnProperties.Details (Hc_ft: 17.0, Fyb: ASTM.Specification.a992.Fy, Fub: ASTM.Specification.a992.Fu))
        @State private var inputString: String = ""
        
        @State private var varsValue: [Double] = [0.0]
        @State private var varsName: [(String, String)] = [("Hc_ft: ", "ft")]

        var body: some View {
            ZStack {
    //            Color.indigo.edgesIgnoringSafeArea(.all)
    //                .opacity(0.50)
                    VStack{
                        Spacer()
                    VStack {
                        Text("Column Height")
                        Text("Feet")
                    }
                    .font(.title)
    //                .foregroundColor(.white)
                    .bold()
                    Form{
                        VStack {
                            
                            
                            Text("1.  Column Height    ft")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            NumericInputView(number: $varsValue[0], name: $varsName[0], placeholder_value: "Enter column height")
                            
                            Text("Warning: Empty records will\nalways be saved as   0.0 ")
                                .foregroundColor(.red)
                                .padding()
                            Spacer()
                        }
                    }
                        

                    HStack {
                        Spacer()
                        Button {
                                
                            columnPropertiesDetailModel.columnPropertiesDetails.Hc_ft = varsValue[0]
                            columnPropertiesDetailModel.saveData()
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

struct ColumnHeightInputView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnHeightInputView()
    }
}
