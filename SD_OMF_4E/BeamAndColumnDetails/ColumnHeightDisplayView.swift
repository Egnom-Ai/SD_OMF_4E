//
//  ColumnHeightDisplayView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct ColumnHeightDisplayView: View {
    @StateObject private var columnPropertiesDetailModel = ColumnPropertiesDetailModel(columnPropertiesDetails: ColumnProperties.Details (Hc_ft: 17.0, Fyb: ASTM.Specification.a992.Fy, Fub: ASTM.Specification.a992.Fu))
    
    var body: some View {
        
        ZStack {
//            Color.teal.edgesIgnoringSafeArea(.all)
//                .opacity(0.25)
                VStack{
                    Spacer()
                VStack {
                    Text("Column Height &")
                    Text("Specification")
                }
                .font(.title)
//                .foregroundColor(.white)
                .bold()
        
        Form {
            Section(header: Text("Column Height     ft")) {
                VStack(alignment: .leading) {
                    Text("1.  Column Height    ft")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("      Hc_ft:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(columnPropertiesDetailModel.columnPropertiesDetails.Hc_ft))
                            .foregroundColor(.blue)
                            .font(.body)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("ft")
                            .frame(alignment: .leading)
                    }
                    .bold()
                }
                VStack(alignment: .leading) {
                    Text("2.  ASTM A992 Fy    kips")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("       Fy:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(columnPropertiesDetailModel.columnPropertiesDetails.Fyb))
                            .foregroundColor(.blue)
                            .font(.body)
                        Text("kips")
                            .frame(alignment: .leading)
                    }
                    .bold()
                }
                VStack(alignment: .leading) {
                    Text("3.  ASTM A992 Fu    kips")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("       Fu:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(columnPropertiesDetailModel.columnPropertiesDetails.Fub))
                            .foregroundColor(.blue)
                            .font(.body)
                        Text("Kips")
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
            columnPropertiesDetailModel.loadData()
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

struct ColumnHeightDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnHeightDisplayView()
    }
}
