//
//  ColumnSelectionView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import SwiftUI

struct ColumnSelectionView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var columnViewModel: ColumnViewModel

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Column", selection: $columnViewModel.selectedColumnId) {
                    ForEach(columnViewModel.columns, id: \.self) { columnId in
                        Text(columnId)
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
            .navigationBarTitle("Select Column")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


struct ColumnSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnSelectionView(columnViewModel: ColumnViewModel())
    }
}

