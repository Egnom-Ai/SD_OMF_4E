//
//  BeamSelectionView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import SwiftUI

struct BeamSelectionView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var beamViewModel: BeamViewModel

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Beam", selection: $beamViewModel.selectedBeamId) {
                    ForEach(beamViewModel.beams, id: \.self) { beamId in
                        Text(beamId)
                    }
                }
                .pickerStyle(WheelPickerStyle())

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                }
            }
            .padding()
            .navigationBarTitle("Select Beam")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


struct BeamSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BeamSelectionView(beamViewModel: BeamViewModel())
    }
}
