//
//  DesignView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct DesignView: View {
    
    @ObservedObject var beamViewModel = BeamViewModel()
    @ObservedObject var columnViewModel = ColumnViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var endPlateViewModel = EndPlateViewModel()
    @ObservedObject var boltViewModel = BoltViewModel()

    var body: some View {
        VStack {
            List {
                Section(header: Text("Beam & Column Data")) {
                    NavigationStack{
                        NavigationLink("Select Beam & Column Sections") {
                            BeamAndColumnSelectionView(beamViewModel: beamViewModel, columnViewModel: columnViewModel)
                        }
                        .foregroundColor(.blue)
                    }
                    
                    NavigationStack{
                        let beamPropertiesDetails = BeamProperties.Details(Lb_ft: 30.0, Fyb: 50.0, Fub: 65.0) // Create an instance
                        let beamPropertiesDetailModel = BeamPropertiesDetailModel(beamPropertiesDetails: beamPropertiesDetails)
                        
                        NavigationLink("Length and Height of Beam & Column") {
                            BeamLengthAndColumnHeightView(beamViewModel: beamViewModel, beamPropertiesDetailModel: beamPropertiesDetailModel)
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Plates & Bolts Specification")) {
                    NavigationStack{
                        NavigationLink("End-Plate & Stiffener ASTM ") {
                            EndPlatePickerView(endPlateViewModel: endPlateViewModel)
                        }
                        .foregroundColor(.blue)
                    }
                    NavigationStack {
                        NavigationLink("Bolts AISC Group: ") {
                            BoltPickerView(boltViewModel: boltViewModel)
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Beam & Column Required Strengh")) {
                    NavigationStack{
                        NavigationLink("Beam & Column Required Strengh") {
                            BeamAndColumnRequiredStrenthView()
                        }
                        .foregroundColor(.blue)
                    }
                }
                
            }
            .navigationTitle("8ES:  OMF EEPM")
        }
    }
}

struct DesignView_Previews: PreviewProvider {
    static var beamViewModel: BeamViewModel = BeamViewModel.init()
    static var columnViewModel: ColumnViewModel = ColumnViewModel.init()
    static var userSettings: UserSettings = UserSettings()
    static var previews: some View {
        NavigationStack{
            DesignView(beamViewModel: beamViewModel, columnViewModel: columnViewModel)
                .environmentObject(UserSettings())
        }
    }
}
