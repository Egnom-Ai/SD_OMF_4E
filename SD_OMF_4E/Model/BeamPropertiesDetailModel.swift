//
//  BeamPropertiesDetailModel.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import Foundation

class BeamPropertiesDetailModel: ObservableObject, Codable {
    @Published var beamPropertiesDetails: BeamProperties.Details

    enum CodingKeys: String, CodingKey {
        case beamPropertiesDetails
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedBeamPropertiesDetails = try container.decode(BeamProperties.Details.self, forKey: .beamPropertiesDetails)

        // Assign the decoded value directly to the @Published property
        self.beamPropertiesDetails = decodedBeamPropertiesDetails
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(beamPropertiesDetails, forKey: .beamPropertiesDetails)
    }

    init(beamPropertiesDetails: BeamProperties.Details) {
        self.beamPropertiesDetails = beamPropertiesDetails
    }

    // Remaining code...


    func saveData() {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(beamPropertiesDetails)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("beamPropertiesDetail.json")
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Data saved successfully!")
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }

    func loadData() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("beamPropertiesDetail.json")

            if FileManager.default.fileExists(atPath: fileURL.path) {
                let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                let decoder = JSONDecoder()
                let data = try decoder.decode(BeamProperties.Details.self, from: jsonString.data(using: .utf8)!)
                beamPropertiesDetails = data
                print("Data loaded successfully!")
            } else {
                print("File does not exist")
            }
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }

    func isValid() -> Bool {
        return isDoubleValue(beamPropertiesDetails.Lb_ftString)
    }

    private func isDoubleValue(_ str: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        if let _ = formatter.number(from: str)?.doubleValue {
            return true
        } else {
            return false
        }
    }
}
