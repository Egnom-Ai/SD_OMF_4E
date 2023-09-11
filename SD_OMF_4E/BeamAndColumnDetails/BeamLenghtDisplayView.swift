//
//  BeamLenghtDisplayView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct BeamLenghtDisplayView: View {
//    @StateObject private var beamPropertiesDetailModel = BeamPropertiesDetailModel(beamPropertiesDetails: BeamProperties.Details (Lb_ft: 30.0, Fyb: ASTM.Specification.a992.Fy, Fub: ASTM.Specification.a992.Fu))
    
    @ObservedObject var beamViewModel: BeamViewModel
    
    var body: some View {
        
        ZStack {
//            Color.teal.edgesIgnoringSafeArea(.all)
//                .opacity(0.25)
                VStack{
                    Spacer()
                VStack {
                    Text("Beam Length &")
                    Text("Specification")
                }
                .font(.title)
//                .foregroundColor(.white)
                .bold()
        
        Form {
            Section(header: Text("Beam Length     ft")) {
                VStack(alignment: .leading) {
                    Text("1.  Beam Length    ft")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("      Lb_ft:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text(formatNumber(beamViewModel.beamPropertiesDetailModel.beamPropertiesDetails.Lb_ft))
                            .foregroundColor(.blue)
                            .font(.body)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

//                        Text(formatNumber(beamPropertiesDetailModel.beamPropertiesDetails.Lb_ft))
//                            beamViewModel.selectedBeamDetails?.Lb_ft ?? 30.0))
//                        Text(formatNumber(beamPropertiesDetailModel.beamPropertiesDetails.Lb_ft))
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
                        Text(formatNumber(beamViewModel.beamPropertiesDetailModel.beamPropertiesDetails.Fyb))
//                        Text(formatNumber(beamPropertiesDetailModel.beamPropertiesDetails.Fyb))
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
                        Text(formatNumber(beamViewModel.beamPropertiesDetailModel.beamPropertiesDetails.Fub))
//                        Text(formatNumber(beamPropertiesDetailModel.beamPropertiesDetails.Fub))
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
//        .onAppear {
//            beamPropertiesDetailModel.loadData()
//        }
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


struct BeamLenghtDisplayView_Previews: PreviewProvider {
    static var beamViewModel: BeamViewModel = BeamViewModel()
    static var previews: some View {
        BeamLenghtDisplayView(beamViewModel: beamViewModel)
    }
}
