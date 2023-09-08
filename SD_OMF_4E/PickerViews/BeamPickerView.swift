//
//  BeamPickerView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct BeamPickerView: View {
    
    @Binding var selectedBeamId: String
    @Binding var isPresentingPicker: Bool

    @State private var pickerBeamId: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Selected Beam ID: \(selectedBeamId)")
                    .padding()

                Picker("Select Beam ID", selection: $selectedBeamId) {
                    ForEach(pickerBeamId, id: \.self) { beamId in
                        Text(beamId)
                    }
                }
                .padding()
            }
            .onAppear {
                do {
                    let beamIds = try PropertyDataManager.getAllIds(BeamProperties.self)
                    if beamIds.isEmpty {
                        print("No beam IDs found")
                    } else {
                        print("Beam IDs:")
                        for beamId in beamIds {
                            print(beamId)
                            pickerBeamId.append(beamId)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            .navigationTitle("Beam Picker")
            .navigationBarItems(trailing: Button("Done") {
                isPresentingPicker = false
            })
        }
    }
}

struct BeamPickerView_Previews: PreviewProvider {
    @State static var selectedBeamId = "W18X40"
    @State static var isPresentingPicker = true

    static var previews: some View {
        BeamPickerView(selectedBeamId: $selectedBeamId, isPresentingPicker: $isPresentingPicker)
    }
}
