//
//  BeamAndColumnSelectionView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import SwiftUI

struct BeamAndColumnSelectionView: View {
    
    @ObservedObject var beamViewModel: BeamViewModel
    @ObservedObject var columnViewModel: ColumnViewModel
    @EnvironmentObject var userSettings: UserSettings

    @State private var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case beamSelection
        case beamDetails
        case columnSelection
        case columnDetails
        
        var id: Int {
            switch self {
            case .beamSelection:
                return 0
            case .beamDetails:
                return 1
            case .columnSelection:
                return 2
            case .columnDetails:
                return 3
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                VStack {
                    Text("Beam and Column")
                    Text("Selection")
                }
                .font(.title2)
                .bold()
                
                Form {
                    Section(header: Text("Beam Selection")) {
                        Button(action: {
                            activeSheet = .beamSelection
                        }) {
                            Text("Beam: \(beamViewModel.selectedBeamId)\t\t\t\tChange")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .onAppear {
                            beamViewModel.selectedBeamId = UserDefaults.standard.string(forKey: "SelectedBeamId") ?? "W18X50"
                        }
                        
                        Button(action: {
                            beamViewModel.selectedBeamId = beamViewModel.selectedBeamId // Set the selected beam
                            activeSheet = .beamDetails
                        }) {
                            Text("Show Details")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    Section(header: Text("Column Selection")) {
                        Button(action: {
                            activeSheet = .columnSelection
                        }) {
                            Text("Column: \(columnViewModel.selectedColumnId)\t\t\t\tChange")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .onAppear {
                            columnViewModel.selectedColumnId = UserDefaults.standard.string(forKey: "SelectedColumnId") ?? "W12X35"
                        }
                        
                        Button(action: {
                            columnViewModel.selectedColumnId = columnViewModel.selectedColumnId // Set the selected column
                            activeSheet = .columnDetails
                        }) {
                            Text("Show Details")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .beamSelection:
                BeamSelectionView(beamViewModel: beamViewModel)
            case .beamDetails:
                BeamDetailsView(beamViewModel: beamViewModel)
            case .columnSelection:
                ColumnSelectionView(columnViewModel: columnViewModel)
            case .columnDetails:
                ColumnDetailsView(columnViewModel: columnViewModel)
            }
        }
    }
}

struct BeamAnd_ColumnSelectionView_Previews: PreviewProvider {
    static var beamViewModel: BeamViewModel = BeamViewModel.init()
    static var columnViewModel: ColumnViewModel = ColumnViewModel.init()
    static var userSettings: UserSettings = UserSettings()
    static var previews: some View {
        NavigationStack{
            BeamAndColumnSelectionView(beamViewModel: beamViewModel, columnViewModel: columnViewModel)
                .environmentObject(UserSettings())
       }
    }
}
