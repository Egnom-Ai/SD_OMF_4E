//
//  NewDesignSheet.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct NewDesignSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var designStore: DesignStore
    
    @ObservedObject var beamViewModel = BeamViewModel() // <- Create BeamViewModel
    @ObservedObject var columnViewModel = ColumnViewModel() // <- Create BeamViewModel

    @State var designTitle = ""
    @State var connectionType = Design.getConnectionType()
    @State var selectedTheme: Theme = .bubblegum

    var body: some View {
        NavigationView {
            NewDesignView(designTitle: $designTitle, selectedTheme: $selectedTheme, beamViewModel: beamViewModel, columnViewModel: columnViewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            handleAddDesign()
                        }
                    }
                    
                }
        }
    }

    func handleAddDesign() {
        let selectedBeam = beamViewModel.selectedBeamProperties ?? BeamProperties.defaultProperties
        let selectedColumn = columnViewModel.selectedColumnProperties ?? ColumnProperties.defaultProperties
        
        let newDesign = Design( connectionType: connectionType, project: designTitle, designers: [], beam: selectedBeam, column: selectedColumn, theme: selectedTheme)
        designStore.designs.append(newDesign)
        saveDesignsToStorage()
        dismiss()
    }

    // Function to save designs to storage
    func saveDesignsToStorage() {
        Task {
            do {
                try await designStore.save(designs: designStore.designs)
                print("Data saved to storage after adding a new item")
            } catch {
                print("Failed to save designs after adding a new item")
            }
        }
    }
}

struct NewDesignSheet_Previews: PreviewProvider {
    static var designStore = DesignStore()
    static var previews: some View {
        NewDesignSheet(designStore: designStore)
    }
}
