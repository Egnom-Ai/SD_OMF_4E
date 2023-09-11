//
//  ColumnDetailsView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import SwiftUI

struct ColumnDetailsView: View {
    @ObservedObject var columnViewModel: ColumnViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack { // Embed in a NavigationView
            VStack {
                Text("Column Details")
                    .font(.title)
                    .padding()

                if let columnProperties = columnViewModel.selectedColumnProperties {

                    Group{
                        Text("AISC Manual Label: \(columnProperties.AISC_Manual_Label)")
                        Text("A: \(columnProperties.A) in")
                        Text("d: \(columnProperties.d) in")
                        Text("tw: \(columnProperties.tw) in")
                        Text("bf: \(columnProperties.bf) in")
                        Text("tf: \(columnProperties.tf) in")

                    }
                    Group{
                        Text("kdes: \(columnProperties.kdes) in")
                        Text("kdet: \(columnProperties.kdet) in")
                        Text("k1: \(columnProperties.k1) in")
                        Text("Zx: \(columnProperties.Zx) in")
                        Text("h_tw: \(columnProperties.h_tw) in")
                        Text("WGi: \(columnProperties.WGi) in")
                    }
                }

            }
            .onAppear {
                columnViewModel.updateColumnProperties()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                columnViewModel.loadColumnIds() // Reload column IDs
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            })
        }
    }
}


struct ColumnDetailsView_Previews: PreviewProvider {
    @StateObject static var viewModel_2: ColumnViewModel = {
        let viewModel_2 = ColumnViewModel()
        viewModel_2.selectedColumnProperties = ColumnProperties.sampleData.first
        return viewModel_2
    }()
    
    @State static var selectedColumn: String = "W12X35"

    static var previews: some View {
        NavigationView {
            ColumnDetailsView(columnViewModel: viewModel_2)
        }
    }
}
