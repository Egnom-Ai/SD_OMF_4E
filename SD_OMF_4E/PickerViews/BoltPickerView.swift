//
//  BoltPickerView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct BoltPickerView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var boltViewModel: BoltViewModel

    var body: some View {
        VStack {
            Picker("Please choose a bolt group", selection: $boltViewModel.selectedGroup) {
                ForEach(Bolt.Group.allCases) { group in
                    Text(group.rawValue).tag(group)
                }
            }
            Text("AISC Bolt Selected\n    Group:    \(boltViewModel.selectedGroup.rawValue)")
        }
    }
}

struct BoltPickerView_Previews: PreviewProvider {
    static var previews: some View {
        BoltPickerView(boltViewModel: BoltViewModel()).environmentObject(UserSettings())
    }
}
