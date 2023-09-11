//
//  BeamAndColumnRequiredStrenthView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct BeamAndColumnRequiredStrenthView: View {
    var body: some View {
        NavigationStack{
            Form {
                NavigationLink("Input: Column Required Strength,   LFRD"){
                    ColumnRequiredStrengthInputView()
                }.foregroundColor(.blue)
                NavigationLink("Display Column Required Strength,    LFRD"){
                    ColumnRequiredStrengthDisplayView()
                }.foregroundColor(.blue)
            }
        }
    }
}

struct BeamAndColumnRequiredStrenthView_Previews: PreviewProvider {
    static var previews: some View {
        BeamAndColumnRequiredStrenthView()
    }
}
