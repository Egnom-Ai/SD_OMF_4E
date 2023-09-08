//
//  ColumnViewModel.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import Foundation
import Combine

class ColumnViewModel: ObservableObject {
    
    @Published var selectedColumnId: String = "W12X35"
    @Published var selectedColumnProperties: ColumnProperties? = nil
    
//    @Published var selectedColumnProperties: ColumnProperties?
    @Published var selectedColumnDetails: ColumnProperties.Details? // Just one set of details
    @Published var columns: [String] = []
    @Published var columnDetails: [String] = []
    
//    @Published var selectedColumnId: String = "" {
//        didSet {
//            UserDefaults.standard.set(selectedColumnId, forKey: "SelectedBColumnId")
//            updateColumnProperties()
//        }
//    }
    
    @Published var columnPropertiesDetailModel = ColumnPropertiesDetailModel(columnPropertiesDetails: ColumnProperties.Details(
        Hc_ft: 17.0, Fyb: ASTM.Specification.a992.Fy, Fub: ASTM.Specification.a992.Fu))
    
    
    
    private enum CodingKeys: CodingKey {
        case selectedColumnId, selectedColumnProperties, selectedColumnDetails, columns, columnDetails, columnPropertiesDetailModel
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.selectedColumnId = try container.decode(String.self, forKey: .selectedColumnId)
        self.selectedColumnProperties = try container.decode(ColumnProperties?.self, forKey: .selectedColumnProperties)
        self.selectedColumnDetails = try container.decode(ColumnProperties.Details?.self, forKey: .selectedColumnDetails)
        self.columns = try container.decode([String].self, forKey: .columns)
        self.columnDetails = try container.decode([String].self, forKey: .columnDetails)
        self.columnPropertiesDetailModel = try container.decode(ColumnPropertiesDetailModel.self, forKey: .columnPropertiesDetailModel)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(selectedColumnId, forKey: .selectedColumnId)
        try container.encode(selectedColumnProperties, forKey: .selectedColumnProperties)
        try container.encode(selectedColumnDetails, forKey: .selectedColumnDetails)
        try container.encode(columns, forKey: .columns)
        try container.encode(columnDetails, forKey: .columnDetails)
        try container.encode(columnPropertiesDetailModel, forKey: .columnPropertiesDetailModel)
    }
    
    
    
    
    

    init() {
        loadColumnIds()
    }

    func loadColumnIds() {
        do {
            self.columns = try getAllColumnIds()
        } catch {
            print("Error: \(error)")
        }
    }

    private func getAllColumnIds() throws -> [String] {
        guard let url = Bundle.main.url(forResource: "aisc-shapes-database-v15-GM-W", withExtension: "json") else {
            return []
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let columnProperties = try decoder.decode([ColumnProperties].self, from: data)

        return columnProperties.map { $0.id }
    }
        
    private func getColumnProperties(selectedColumn: String = "W12X35") throws -> ColumnProperties? {
        guard let url = Bundle.main.url(forResource: "aisc-shapes-database-v15-GM-W", withExtension: "json") else {
            return nil
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let columnProperties = try decoder.decode([ColumnProperties].self, from: data)

        return columnProperties.first { $0.id == selectedColumn }
    }
    
    func updateColumnProperties() {
        do {
            // Fetch the beam properties based on the selected beam
            guard let columnProperties = try getColumnProperties(selectedColumn: selectedColumnId) else {
                // Handle error or return if column properties are not found
                return
            }
            
            // Update the selected beam properties
            selectedColumnProperties = columnProperties
            
            // Update the beam details array with the desired properties
            columnDetails = [
                "AISC Manual Label: \(columnProperties.AISC_Manual_Label)",
                "A: \(columnProperties.A) in",
                "d: \(columnProperties.d) in",
                "tw: \(columnProperties.tw) in",
                "bf: \(columnProperties.bf) in",
                "tf: \(columnProperties.tf) in",
                "kdes: \(columnProperties.kdes) in",
                "kdet: \(columnProperties.kdet) in",
                "k1: \(columnProperties.k1) in",
                "Zx: \(columnProperties.Zx) in",
                "h_tw: \(columnProperties.h_tw) in",
                "WGi: \(columnProperties.WGi) in"
            ]
        } catch {
            // Handle error if any exception occurs while fetching beam properties
            print("Error fetching column properties: \(error)")
        }
    }
    func updateColumnDetails(detail: ColumnProperties.Details) {
        // directly update the struct Details for the selectedBeamId
        self.selectedColumnDetails = detail
    }
}
