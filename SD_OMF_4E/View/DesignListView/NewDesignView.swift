//
//  NewDesignView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct NewDesignView: View {
//    @Binding var design: Design
    @Binding var designTitle: String
    @Binding var selectedTheme: Theme
    @ObservedObject var beamViewModel: BeamViewModel  // <- Accept BeamViewModel
    @ObservedObject var columnViewModel: ColumnViewModel  // <- Accept ColumnViewModel

    @State private var isPresentingBeamPicker = false
    @State private var isPresentingColumnPicker = false  // <- Add this for Column Picker

    var body: some View {
        Form {
            Section(header: Text("Project Name")) {
                TextField("Name", text: $designTitle)
                
            }
            
            Section(header: Text("Theme")) {
                ThemePicker(selection: $selectedTheme)
            }
            
            Section(header: Text("Beam Properties")) {
                Button(beamViewModel.selectedBeamId.isEmpty ? "Select Beam" : "Selected: \(beamViewModel.selectedBeamId)") {
                    isPresentingBeamPicker.toggle()
                }
                .sheet(isPresented: $isPresentingBeamPicker) {
                    BeamPickerView(selectedBeamId: $beamViewModel.selectedBeamId, isPresentingPicker: $isPresentingBeamPicker)
                }

                if let selectedBeamProperties = beamViewModel.selectedBeamProperties {
                    // Show the selected beam properties here
                    // This is just an example, you may want to render it differently
                    Text("AISC Manual Label: \(selectedBeamProperties.AISC_Manual_Label)")
                    // ... other properties


                }
            }
            Section(header: Text("Column Properties")) {
                Button(columnViewModel.selectedColumnId.isEmpty ? "Select Column" : "Selected: \(columnViewModel.selectedColumnId)") {
                    if !beamViewModel.selectedBeamId.isEmpty {
                        isPresentingColumnPicker.toggle()
                    }
                }
                .disabled(beamViewModel.selectedBeamId.isEmpty)
                .sheet(isPresented: $isPresentingColumnPicker) {
                    ColumnPickerView(selectedColumnId: $columnViewModel.selectedColumnId, isPresentingPicker: $isPresentingColumnPicker, selectedBeamBf: beamViewModel.selectedBeamProperties?.bf)
                }

                    if let selectedColumnProperties = columnViewModel.selectedColumnProperties {
                        // Show the selected column properties here
                        // This is just an example, you may want to render it differently
                        Text("AISC Manual Label: \(selectedColumnProperties.AISC_Manual_Label)") // Assuming your column has similar properties
                        // ... other properties

                }
            }
        }

    }
}

struct NewDesignView_Previews: PreviewProvider {
    @State static var designTitle = "Example Design"
    @State static var selectedTheme = Theme.orange

    static var previews: some View {
        // Create a BeamViewModel instance for the preview
        let beamViewModel = BeamViewModel()
        let columnViewModel = ColumnViewModel()
        // Set selectedBeamProperties of BeamViewModel for the preview
        beamViewModel.selectedBeamProperties = BeamProperties(
            id: "W18X40",
            AISC_Manual_Label: "W18X40",
            d: "17.9",
            tw: "0.315",
            bf: "6.02",
            tf: "0.525",
            Zx: "78.4",
            WGi: "3.5"
        )

        columnViewModel.selectedColumnProperties = ColumnProperties(
            id: "W12X35",
            AISC_Manual_Label: "W12X35",
            A: "10.3",
            d: "12.5",
            tw: "0.3",
            bf: "6.56",
            tf: "0.52",
            kdes: "0.82",
            kdet: "1.1875",
            k1: "0.75",
            Zx: "51.2",
            h_tw: "36.2",
            WGi: "3.5")
        // Return the EditDesignView
        return NewDesignView(designTitle: $designTitle, selectedTheme: $selectedTheme, beamViewModel: beamViewModel, columnViewModel: columnViewModel)
    }
}
