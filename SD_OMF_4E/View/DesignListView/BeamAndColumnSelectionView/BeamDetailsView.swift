//
//  BeamDetailsView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import SwiftUI

struct BeamDetailsView: View {
    @ObservedObject var beamViewModel: BeamViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack { // Embed in a NavigationView
            VStack {
                Text("Beam Details")
                    .font(.title)
                    .padding()

                if let beamProperties = beamViewModel.selectedBeamProperties {
                    Text("AISC Manual Label: \(beamProperties.AISC_Manual_Label)")
                    Text("d: \(beamProperties.d) in")
                    Text("tw: \(beamProperties.tw) in")
                    Text("bf: \(beamProperties.bf) in")
                    Text("tf: \(beamProperties.tf) in")
                    Text("Zx: \(beamProperties.Zx) in")
                    Text("WGi: \(beamProperties.WGi) in")
                }

            }
            .onAppear {
                beamViewModel.updateBeamProperties()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                beamViewModel.loadBeamIds() // Reload beam IDs
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            })
        }
    }
}


struct BeamDetailsView_Previews: PreviewProvider {
    @StateObject static var viewModel: BeamViewModel = {
        let viewModel = BeamViewModel()
        viewModel.selectedBeamProperties = BeamProperties.sampleData.first
        return viewModel
    }()
    
    @State static var selectedBeam: String = "W18X50"

    static var previews: some View {
        NavigationView {
            BeamDetailsView(beamViewModel: viewModel)
        }
    }
}
