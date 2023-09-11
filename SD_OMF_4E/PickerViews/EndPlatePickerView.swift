//
//  EndPlatePickerView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct EndPlatePickerView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var endPlateViewModel: EndPlateViewModel

    var body: some View {
        VStack {
            Picker("Please choose a specification", selection: $endPlateViewModel.selectedSpecification) {
                ForEach(ASTM.Specification.allCases) { specification in
                    Text(specification.rawValue).tag(specification)
                }
            }
            Text("Selected Specification:\n          ASTM  \(endPlateViewModel.selectedSpecification.rawValue)")
        }
    }
}

struct EndPlatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        EndPlatePickerView(endPlateViewModel: EndPlateViewModel()).environmentObject(UserSettings())
    }
}
