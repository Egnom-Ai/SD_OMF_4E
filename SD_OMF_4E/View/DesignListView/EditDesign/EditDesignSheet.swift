//
//  EditDesignSheet.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct EditDesignSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var designStore: DesignStore
    @ObservedObject var beamViewModel = BeamViewModel()
    @ObservedObject var columnViewModel = ColumnViewModel()
    
    var designIndex: Int  // Index of the design in the designs array
    
    @State var designTitle: String
    @State var selectedTheme: Theme
    
    init(designStore: DesignStore, designIndex: Int) {
        self.designStore = designStore
        self.designIndex = designIndex
        self._designTitle = State(initialValue: designStore.designs[designIndex].project)
        self._selectedTheme = State(initialValue: designStore.designs[designIndex].theme)
        
        // Initialize the Beam and Column View Models
        self.beamViewModel.selectedBeamProperties = designStore.designs[designIndex].beam
        self.columnViewModel.selectedColumnProperties = designStore.designs[designIndex].column
    }

    var body: some View {
        NavigationView {
            EditDesignView(designTitle: $designTitle, selectedTheme: $selectedTheme, beamViewModel: beamViewModel, columnViewModel: columnViewModel)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            handleEditDesign()
                        }
                    }
                }
        }
    }

    func handleEditDesign() {
        designStore.designs[designIndex].project = designTitle
        designStore.designs[designIndex].theme = selectedTheme
        designStore.designs[designIndex].beam = beamViewModel.selectedBeamProperties ?? BeamProperties.defaultProperties
        designStore.designs[designIndex].column = columnViewModel.selectedColumnProperties ?? ColumnProperties.defaultProperties
        
        saveDesignsToStorage()
        dismiss()
    }

    // Function to save designs to storage
    func saveDesignsToStorage() {
        Task {
            do {
                try await designStore.save(designs: designStore.designs)
                print("Data saved to storage after editing a design")
            } catch {
                print("Failed to save designs after editing a design")
            }
        }
    }
}

//struct EditDesignSheet_Previews: PreviewProvider {
//    static var designStore = DesignStore()
//    
//    static var previews: some View {
//        EditDesignSheet(designStore: designStore, designIndex: )
//    }
//}
