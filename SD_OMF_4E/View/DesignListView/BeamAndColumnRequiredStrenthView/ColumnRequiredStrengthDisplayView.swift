//
//  ColumnRequiredStrengthDisplayView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct ColumnRequiredStrengthDisplayView: View {
    @StateObject private var columnRequiredStrengthModel = ColumnRequiredStrengthModel(columnRequiredStrength: ColumnRequiredStrength(Puc_1: 0.0, Vuc: 0.0, Muc_top: 0.0, Muc_bot: 0.0))
    
    var body: some View {
        
        ZStack {
//            Color.teal.edgesIgnoringSafeArea(.all)
//                .opacity(0.25)
                VStack{
                    Spacer()
                VStack {
                    Text("Column Required Strength")
                    Text("LFRD")
                }
                .font(.title)
//                .foregroundColor(.white)
                .bold()
        
        Form {
            Section(header: Text("Column Required Strength     LFRD")) {
                VStack(alignment: .leading) {
                    Text("1.  Column Axial Load    kips")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("      Pu:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(columnRequiredStrengthModel.columnRequiredStrength.Puc_1))
                            .foregroundColor(.blue)
                            .font(.body)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("kips")
                            .frame(alignment: .leading)
                    }
                    .bold()
                }
                VStack(alignment: .leading) {
                    Text("2.  Column Shear Load    kips")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("       Vu:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(columnRequiredStrengthModel.columnRequiredStrength.Vuc))
                            .foregroundColor(.blue)
                            .font(.body)
                        Text("kips")
                            .frame(alignment: .leading)
                    }
                    .bold()
                }
                VStack(alignment: .leading) {
                    Text("3.  Column Moment Load    kip-ft")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("       Mu:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(columnRequiredStrengthModel.columnRequiredStrength.Muc_top))
                            .foregroundColor(.blue)
                            .font(.body)
                        Text("Kip-ft")
                            .frame(alignment: .leading)
                    }
                    .bold()
                }
                Text("\tUploaded values from storage")
                    .frame(alignment: .center)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            columnRequiredStrengthModel.loadData()
        }
    }}
    }
    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "N/A"
    }

}

struct ColumnRequiredStrengthDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnRequiredStrengthDisplayView()
    }
}
