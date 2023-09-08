//
//  ColumnPickerView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct ColumnPickerView: View {
    @Binding var selectedColumnId: String
    @Binding var isPresentingPicker: Bool
    let selectedBeamBf: String?

    @State private var pickerColumnId: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Selected Column ID: \(selectedColumnId)")
                    .padding()

                Picker("Select Column ID", selection: $selectedColumnId) {
                    ForEach(pickerColumnId, id: \.self) { columnId in
                        Text(columnId)
                    }
                }
                .padding()
            }
            .onAppear {
                do {
                    let filteredColumnIds = try PropertyDataManager.getAllFilteredBeamIds(referenceBf: Double(selectedBeamBf ?? "") ?? 0.0, prefixes: ["W10", "W12", "W14", "W16"])
                    if filteredColumnIds.isEmpty {
                        print("No column IDs found")
                    } else {
                        print("Column IDs:")
                        for columnId in filteredColumnIds {
                            print(columnId)
                            pickerColumnId.append(columnId)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            .navigationTitle("Column Picker")
            .navigationBarItems(trailing: Button("Done") {
                isPresentingPicker = false
            })
        }
    }
}
