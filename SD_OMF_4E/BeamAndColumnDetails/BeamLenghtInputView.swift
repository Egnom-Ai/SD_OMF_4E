//
//  BeamLenghtInputView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import SwiftUI

struct BeamLenghtInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var beamViewModel: BeamViewModel
    @ObservedObject var beamPropertiesDetailModel : BeamPropertiesDetailModel
    @State private var inputString: String = ""
    
    @State private var varsValue: [Double] = [0.0]
    @State private var varsName: [(String, String)] = [("Lb_ft: ", "ft")]
    
    // This is a helper to keep the value of Lb_ft in sync.
       private var lb_ftBinding: Binding<Double> {
           Binding(
               get: { self.beamViewModel.beamPropertiesDetailModel.beamPropertiesDetails.Lb_ft },
               set: { self.beamViewModel.beamPropertiesDetailModel.beamPropertiesDetails.Lb_ft = $0 }
           )
       }

       var body: some View {
           ZStack {
               VStack{
                   Spacer()
                   VStack {
                       Text("Beam Length")
                       Text("Feet")
                   }
                   .font(.title)
                   .bold()
                   Form{
                       VStack {
                           Text("1.  Beam Length    ft")
                               .frame(maxWidth: .infinity, alignment: .leading)
                           // Pass the binding here
                           NumericInputView(number: lb_ftBinding, name: $varsName[0], placeholder_value: "Enter beam Length")
                           
                           Text("Warning: Empty records will\nalways be saved as   0.0 ")
                               .foregroundColor(.red)
                               .padding()
                           Spacer()
                       }
                   }

                    

                HStack {
                    Spacer()
                    Button {
                        beamViewModel.updateBeamDetails(detail: beamPropertiesDetailModel.beamPropertiesDetails)
 //                       beamPropertiesDetailModel.saveData()
                            print("Saved value: \(varsValue)")
                            presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save Values")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    .background(Color.blue)
                    .cornerRadius(5)
                    Spacer()
                }
            }
        }

    }
    
    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = Int.max
        return formatter.string(from: NSNumber(value: value)) ?? "N/A"
    }
}

struct BeamLenghtInputView_Previews: PreviewProvider {
    static var previews: some View {
        let beamViewModel = BeamViewModel()
        let beamPropertiesDetailModel = BeamPropertiesDetailModel(beamPropertiesDetails: BeamProperties.Details(Lb_ft: 30.0, Fyb: 50.0, Fub: 65.0))
        return BeamLenghtInputView(beamViewModel: beamViewModel, beamPropertiesDetailModel: beamPropertiesDetailModel)
    }
}

