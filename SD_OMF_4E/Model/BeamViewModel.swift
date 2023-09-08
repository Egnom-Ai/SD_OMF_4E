//
//  BeamViewModel.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import Foundation
import Combine

class BeamViewModel: ObservableObject, Codable {

    @Published var selectedBeamId: String = ""
    @Published var selectedBeamProperties: BeamProperties? = nil

//    @Published var selectedBeamProperties: BeamProperties?
    @Published var selectedBeamDetails: BeamProperties.Details? // Just one set of details
    @Published var beams: [String] = []
    @Published var beamDetails: [String] = []

//    @Published var selectedBeamId: String = "" {
//        didSet {
//            UserDefaults.standard.set(selectedBeamId, forKey: "SelectedBeamId")
//            updateBeamProperties()
//        }
//    }

    @Published var beamPropertiesDetailModel = BeamPropertiesDetailModel(beamPropertiesDetails: BeamProperties.Details(Lb_ft: 30.0, Fyb: ASTM.Specification.a992.Fy, Fub: ASTM.Specification.a992.Fu))
    
    
    
        private enum CodingKeys: CodingKey {
            case selectedBeamId, selectedBeamProperties, selectedBeamDetails, beams, beamDetails, beamPropertiesDetailModel
        }
    
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
    
            self.selectedBeamId = try container.decode(String.self, forKey: .selectedBeamId)
            self.selectedBeamProperties = try container.decode(BeamProperties?.self, forKey: .selectedBeamProperties)
            self.selectedBeamDetails = try container.decode(BeamProperties.Details?.self, forKey: .selectedBeamDetails)
            self.beams = try container.decode([String].self, forKey: .beams)
            self.beamDetails = try container.decode([String].self, forKey: .beamDetails)
            self.beamPropertiesDetailModel = try container.decode(BeamPropertiesDetailModel.self, forKey: .beamPropertiesDetailModel)
        }
    
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
    
            try container.encode(selectedBeamId, forKey: .selectedBeamId)
            try container.encode(selectedBeamProperties, forKey: .selectedBeamProperties)
            try container.encode(selectedBeamDetails, forKey: .selectedBeamDetails)
            try container.encode(beams, forKey: .beams)
            try container.encode(beamDetails, forKey: .beamDetails)
            try container.encode(beamPropertiesDetailModel, forKey: .beamPropertiesDetailModel)
        }
    
    
    
    

    init() {
        loadBeamIds()

    }

    func loadBeamIds() {
        do {
            self.beams = try getAllBeamIds()
        } catch {
            print("Error: \(error)")
        }
    }

    private func getAllBeamIds() throws -> [String] {
        guard let url = Bundle.main.url(forResource: "aisc-shapes-database-v15-GM-W", withExtension: "json") else {
            return []
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let beamProperties = try decoder.decode([BeamProperties].self, from: data)

        return beamProperties.map { $0.id }
    }

    private func getBeamProperties(selectedBeam: String) throws -> BeamProperties? {
        guard let url = Bundle.main.url(forResource: "aisc-shapes-database-v15-GM-W", withExtension: "json") else {
            return nil
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let beamProperties = try decoder.decode([BeamProperties].self, from: data)

        return beamProperties.first { $0.id == selectedBeam }
    }

    func updateBeamProperties() {
        do {
            // Fetch the beam properties based on the selected beam
            guard let beamProperties = try getBeamProperties(selectedBeam: selectedBeamId) else {
                // Handle error or return if beam properties are not found
                return
            }

            // Update the selected beam properties
            selectedBeamProperties = beamProperties

            // Update the beam details array with the desired properties
            beamDetails = [
                "AISC Manual Label: \(beamProperties.AISC_Manual_Label)",
                "d: \(beamProperties.d) in",
                "tw: \(beamProperties.tw) in",
                "bf: \(beamProperties.bf) in",
                "tf: \(beamProperties.tf) in",
                "Zx: \(beamProperties.Zx) in",
                "WGi: \(beamProperties.WGi) in"
            ]

        } catch {
            // Handle error if any exception occurs while fetching beam properties
            print("Error fetching beam properties: \(error)")
        }
    }

    func updateBeamDetails(detail: BeamProperties.Details) {
        // directly update the struct Details for the selectedBeamId
        self.selectedBeamDetails = detail
    }
}
