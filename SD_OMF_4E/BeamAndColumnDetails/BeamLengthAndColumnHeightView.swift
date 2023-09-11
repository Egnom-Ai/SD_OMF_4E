//
//  BeamLengthAndColumnHeightView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct BeamLengthAndColumnHeightView: View {
    @ObservedObject var beamViewModel: BeamViewModel
    @ObservedObject var beamPropertiesDetailModel : BeamPropertiesDetailModel
    
    var body: some View {
        ZStack {
            //            Color.indigo.edgesIgnoringSafeArea(.all)
            //                .opacity(0.50)
            VStack{
                Spacer()
                VStack {
                    Text("Beam & Column")
                    Text("Lenght and Height")
                }
                .font(.title)
                //                .foregroundColor(.white)
                .bold()
                Text("(Feet)")
                NavigationStack{
                    
                    Form {
                        Section(header: Text("Beam Length")) {
                            NavigationLink("Input: Beam Length,   ft"){
                                BeamLenghtInputView(beamViewModel: beamViewModel, beamPropertiesDetailModel: beamPropertiesDetailModel)
                            }.foregroundColor(.blue)
                            NavigationLink("Display Beam Length,    ft"){
                                BeamLenghtDisplayView(beamViewModel: beamViewModel)
                            }.foregroundColor(.blue)
                        }
                        
                        Section(header: Text("Column Height")) {
                            NavigationLink("Input: Column Height,   ft"){
                                ColumnHeightInputView()
                            }.foregroundColor(.blue)
                            NavigationLink("Display Column Height,    ft"){
                                ColumnHeightDisplayView()
                            }.foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

struct BeamLengthAndColumnHeightView_Previews: PreviewProvider {
    static var beamViewModel = BeamViewModel()
    static var previews: some View {
        let beamPropertiesDetails = BeamProperties.Details(Lb_ft: 30.0, Fyb: 50.0, Fub: 65.0) // Create an instance here
        let beamPropertiesDetailModel = BeamPropertiesDetailModel(beamPropertiesDetails: beamPropertiesDetails)
        
        return BeamLengthAndColumnHeightView(beamViewModel: beamViewModel, beamPropertiesDetailModel: beamPropertiesDetailModel)
    }
}
