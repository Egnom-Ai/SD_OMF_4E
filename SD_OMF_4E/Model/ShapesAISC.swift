//
//  ShapesAISC.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import Foundation
import Combine

// MARK: - Property Protocol

protocol Property: Decodable {
    var id: String { get }
    static var fileName: String { get }
}

// MARK: - BeamProperties Class

class BeamProperties: ObservableObject, Property, Codable {
    @Published var id: String
    @Published var AISC_Manual_Label: String
    @Published var d: String
    @Published var tw: String
    @Published var bf: String
    @Published var tf: String
    @Published var Zx: String
    @Published var WGi: String
    
    var dValue: Double? { Double(d) }
    var twValue: Double? { Double(tw) }
    var bfValue: Double? { Double(bf) }
    var tfValue: Double? { Double(tf) }
    var ZxValue: Double? { Double(Zx) }
    var WGiValue: Double? { Double(WGi) }
    
    static var fileName: String { "aisc-shapes-database-v15-GM-W" }
    
    init(id: String, AISC_Manual_Label: String, d: String, tw: String, bf: String, tf: String, Zx: String, WGi: String) {
        self.id = id
        self.AISC_Manual_Label = AISC_Manual_Label
        self.d = d
        self.tw = tw
        self.bf = bf
        self.tf = tf
        self.Zx = Zx
        self.WGi = WGi
    }
    
    // Decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.AISC_Manual_Label = try container.decode(String.self, forKey: .AISC_Manual_Label)
        self.d = try container.decode(String.self, forKey: .d)
        self.tw = try container.decode(String.self, forKey: .tw)
        self.bf = try container.decode(String.self, forKey: .bf)
        self.tf = try container.decode(String.self, forKey: .tf)
        self.Zx = try container.decode(String.self, forKey: .Zx)
        self.WGi = try container.decode(String.self, forKey: .WGi)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, AISC_Manual_Label, d, tw, bf, tf, Zx, WGi
    }
    
    // Encodable protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(AISC_Manual_Label, forKey: .AISC_Manual_Label)
        try container.encode(d, forKey: .d)
        try container.encode(tw, forKey: .tw)
        try container.encode(bf, forKey: .bf)
        try container.encode(tf, forKey: .tf)
        try container.encode(Zx, forKey: .Zx)
        try container.encode(WGi, forKey: .WGi)
    }
}

extension BeamProperties {
    struct Details: Identifiable, Codable {
        var id: UUID = UUID()
        var Lb_ft : Double
        var Fyb : Double
        var Fub : Double
        
        var Lb_ftString: String {
            get {
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.decimalSeparator = "."
                formatter.numberStyle = .decimal
                return formatter.string(from: NSNumber(value: Lb_ft)) ?? ""
            }
            set {
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.decimalSeparator = "."
                if let number = formatter.number(from: newValue)?.doubleValue {
                    Lb_ft = number
                }
            }
        }
        
//        init(id: UUID = UUID(), Lb_ft: Double = 30.0, Fyb: Double, Fub: Double) {
//            self.id = id
//            self.Lb_ft = Lb_ft
//            self.Fyb = Fyb
//            self.Fub = Fub
//        }
    }
}


extension BeamProperties {
    static var sampleData: [BeamProperties] {
        [
            BeamProperties(
                id: "W18X40",
                AISC_Manual_Label: "W18X40",
                d: "17.9",
                tw: "0.315",
                bf: "6.02",
                tf: "0.525",
                Zx: "78.4",
                WGi: "3.5"),
            BeamProperties(id: "W18X40", AISC_Manual_Label: "W18X40", d: "17.9", tw: "0.315", bf: "6.02", tf: "0.525", Zx: "78.4", WGi: "3.5")
        ]
    }
}

extension BeamProperties {
    static var defaultProperties: BeamProperties {
        BeamProperties(id: "", AISC_Manual_Label: "", d: "", tw: "", bf: "", tf: "", Zx: "", WGi: "")
    }
}


// MARK: - Column Properties Class

class ColumnProperties: ObservableObject, Property, Codable{
    @Published var id: String
    @Published var AISC_Manual_Label: String
    @Published var A: String
    @Published var d: String
    @Published var tw: String
    @Published var bf: String
    @Published var tf: String
    @Published var kdes: String
    @Published var kdet: String
    @Published var k1: String
    @Published var Zx: String
    @Published var h_tw: String
    @Published var WGi: String
    
    var dValue: Double? { Double(d) }
    var AValue: Double? { Double(A) }
    var twValue: Double? { Double(tw) }
    var bfValue: Double? { Double(bf) }
    var tfValue: Double? { Double(tf) }
    var kdesValue: Double? { Double(kdes) }
    var kdetValue: Double? { Double(kdet) }
    var k1Value: Double? { Double(k1) }
    var ZxValue: Double? { Double(Zx) }
    var h_twValue: Double? { Double(h_tw) }
    var WGiValue: Double? { Double(WGi) }
    
    static var fileName: String { "aisc-shapes-database-v15-GM-W" }
    
    init(id: String, AISC_Manual_Label: String, A: String, d: String, tw: String, bf: String, tf: String, kdes: String, kdet: String, k1: String, Zx: String, h_tw: String, WGi: String) {
        self.id = id
        self.AISC_Manual_Label = AISC_Manual_Label
        self.A = A
        self.d = d
        self.tw = tw
        self.bf = bf
        self.tf = tf
        self.kdes = kdes
        self.kdet = kdet
        self.k1 = k1
        self.Zx = Zx
        self.h_tw = h_tw
        self.WGi = WGi
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.AISC_Manual_Label = try container.decode(String.self, forKey: .AISC_Manual_Label)
        self.A = try container.decode(String.self, forKey: .A)
        self.d = try container.decode(String.self, forKey: .d)
        self.tw = try container.decode(String.self, forKey: .tw)
        self.bf = try container.decode(String.self, forKey: .bf)
        self.tf = try container.decode(String.self, forKey: .tf)
        self.kdes = try container.decode(String.self, forKey: .kdes)
        self.kdet = try container.decode(String.self, forKey: .kdet)
        self.k1 = try container.decode(String.self, forKey: .k1)
        self.Zx = try container.decode(String.self, forKey: .Zx)
        self.h_tw = try container.decode(String.self, forKey: .h_tw)
        self.WGi = try container.decode(String.self, forKey: .WGi)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, AISC_Manual_Label, A, d, tw, bf, tf, kdes, kdet, k1, Zx, h_tw, WGi
    }
    
    // Encodable protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(A, forKey: .A)
        try container.encode(id, forKey: .id)
        try container.encode(AISC_Manual_Label, forKey: .AISC_Manual_Label)
        try container.encode(d, forKey: .d)
        try container.encode(tw, forKey: .tw)
        try container.encode(bf, forKey: .bf)
        try container.encode(tf, forKey: .tf)
        try container.encode(kdes, forKey: .kdes)
        try container.encode(kdet, forKey: .kdet)
        try container.encode(k1, forKey: .k1)
        try container.encode(Zx, forKey: .Zx)
        try container.encode(h_tw, forKey: .h_tw)
        try container.encode(WGi, forKey: .WGi)
    }
}

extension ColumnProperties {
    struct Details: Identifiable, Codable {
        var id: UUID = UUID()
        var Hc_ft : Double
        var Fyb : Double
        var Fub : Double
        
        var Hc_ftString: String {
            get {
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.decimalSeparator = "."
                formatter.numberStyle = .decimal
                return formatter.string(from: NSNumber(value: Hc_ft)) ?? ""
            }
            set {
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.decimalSeparator = "."
                if let number = formatter.number(from: newValue)?.doubleValue {
                    Hc_ft = number
                }
            }
        }
        
//        init(id: UUID = UUID(), Hc_ft: Double =  17.0, Fyb: Double, Fub: Double) {
//            self.id = id
//            self.Hc_ft = Hc_ft
//            self.Fyb = Fyb
//            self.Fub = Fub
//        }
    }
}

extension ColumnProperties {
    static var sampleData: [ColumnProperties] {
        [
            ColumnProperties(
                id: "W12X35",
                AISC_Manual_Label: "W12X35",
                A: "10.3",
                d: "12.5",
                tw: "0.3",
                bf: "6.56",
                tf: "0.52",
                kdes: "0.82",
                kdet: "1.1875",
                k1: "0.75",
                Zx: "51.2",
                h_tw: "36.2",
                WGi: "3.5"),
            ColumnProperties(id: "W12X35", AISC_Manual_Label: "W12X35", A: "10.3", d: "12.5", tw: "0.3", bf: "6.56", tf: "0.52", kdes: "0.82", kdet: "1.1875", k1: "0.75", Zx: "51.2", h_tw: "36.2", WGi: "3.5")
        ]
    }
}

extension ColumnProperties {
    static var defaultProperties: ColumnProperties {
        ColumnProperties(id: "", AISC_Manual_Label: "", A: "", d: "", tw: "", bf: "", tf: "", kdes: "", kdet: "", k1: "", Zx: "", h_tw: "", WGi: "")
    }
}



// MARK: - Plates and Bolts

struct EndPlateProperties  {
    let id: String
    let Fy_p: Double
    let Fu_p: Double

}

extension EndPlateProperties {
    static var sampleData: [EndPlateProperties]
    {
        [
            EndPlateProperties(
                id: "A572",
                Fy_p: 50.0,
                Fu_p: 65.0
            ),
            
            EndPlateProperties(
                id: "A992",
                Fy_p: 50.0,
                Fu_p: 65.0
            )
        ]
    }
}

struct ContinuityPlatesProperties {
    let id: String
    let Fy_cp: Double
    let Fu_cp: Double
}



// MARK: - Property Data Manager

class PropertyDataManager {
    
    static func getProperties<T: Property>(selectedID: String) throws -> T? {
        guard let url = Bundle.main.url(forResource: T.fileName, withExtension: "json") else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let properties = try decoder.decode([T].self, from: data)
        
        return properties.first { $0.id == selectedID }
    }
    
    static func getAllIds<T: Property>(_ type: T.Type) throws -> [String] {
        guard let url = Bundle.main.url(forResource: T.fileName, withExtension: "json") else {
            return []
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let properties = try decoder.decode([T].self, from: data)
        
        return properties.map { $0.id }
    }
    
    static func getAllBeamIdsAndBf() throws -> [(String, String)] {
        guard let url = Bundle.main.url(forResource: "aisc-shapes-database-v15-GM-W", withExtension: "json") else {
            return []
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let beamProperties = try decoder.decode([BeamProperties].self, from: data)

        return beamProperties.map { ($0.id, $0.bf) }
    }


    static func filterBeamIdsForPrefix(idsAndBfs: [(String, String)], prefixes: [String]) -> [(String, String)] {
        let filteredIdsAndBfs = idsAndBfs.filter { idAndBf in
            let (id, _) = idAndBf
            return prefixes.contains(where: { id.hasPrefix($0) })
        }
        return filteredIdsAndBfs
    }

    static func filterIdsByBf(idsAndBfs: [(String, String)], referenceBf: Double) -> [String] {
        let filteredIds = idsAndBfs.filter { idAndBf in
            let (_, bf) = idAndBf
            return Double(bf) ?? 0.0 >= referenceBf
        }
        return filteredIds.map { $0.0 }
    }

    static func getAllFilteredBeamIds(referenceBf: Double, prefixes: [String]) throws -> [String] {
        let idsAndBfs = try getAllBeamIdsAndBf()
        let filteredIdsAndBfs = filterBeamIdsForPrefix(idsAndBfs: idsAndBfs, prefixes: prefixes)
        let filteredIds = filterIdsByBf(idsAndBfs: filteredIdsAndBfs, referenceBf: referenceBf)
        return filteredIds
    }
        
    /*
     
    USAGE:
     
    do {
        let referenceBf = 15.0 // Replace with your desired reference bf value
        let prefixes = ["W10", "W12", "W14", "W16"] // Replace with your desired prefixes
        let filteredIds = try getAllFilteredBeamIds(referenceBf: referenceBf, prefixes: prefixes)
        for id in filteredIds {
            print("Filtered ID: \(id)")
        }
    } catch {
        print("Error: \(error)")
    }
    */
    
}
