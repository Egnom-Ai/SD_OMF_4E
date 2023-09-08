//
//  Constants.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import Foundation

struct Constants {
    static let boltsDesignation: [Float: String] = [
        0.625 : "5/8",
        0.750 : "3/4",
        0.875 : "7/8",
        1.000 : "1",
        1.125 : "1 1/8",
        1.250 : "1 1/4",
        1.375 : "1 3/8",
        1.5   : "1 1/2"
    ]
}

struct Bolt {
    enum Group: String, CaseIterable, Identifiable {
        case a_n = "A-N"
        case a_x = "A-X"
        case b_n = "B-N"
        case b_x = "B-X"
    
        var id: String { self.rawValue }
    
    var Fnt: Float {
        switch self {
        case .a_n, .a_x:
            return 90.0
        case .b_n, .b_x:
            return 113.0
        }
    }
    
    var Fnv: Float {
        switch self {
        case .a_n:
            return 54.0
        case .a_x, .b_n:
            return 68.0
        case .b_x:
            return 84.0
            }
        }
    }
}

struct ASTM {
    enum Specification: String, CaseIterable, Identifiable {
        case a36 = "A36"
        case a572 = "A572"
        case a992 = "A992"

        var id: String { self.rawValue }

        var Fy: Double {
            switch self {
            case .a36:
                return 36.0
            case .a572:
                return 50.0
            case .a992:
                return 50.0
            }
        }

        var Fu: Double {
            switch self {
            case .a36:
                return 58.0
            case .a572:
                return 65.0
            case .a992:
                return 65.0
            }
        }
    }
}

let Fyb = ASTM.Specification.a572.Fy
let Fub = ASTM.Specification.a572.Fu

let Fyc = ASTM.Specification.a572.Fy
let Fuc = ASTM.Specification.a572.Fu


let beam_ASTM = "ASTM A992"
let column_ASTM = "ASTM A992"
let electrode = "70 ksi"

let bolts_designation: [Double: String] = [0.625: "5/8", 0.750: "3/4", 0.875: "7/8", 1.000: "1", 1.125: "1 1/8",
                                           1.250: "1 1/4", 1.375: "1 3/8", 1.5: "1 1/2"]

let bolts_diameters: [String: Double] = ["5/8": 0.625, "3/4": 0.750, "7/8": 0.875, "1": 1.000, "1 1/8": 1.125,
                                         "1 1/4": 1.250, "1 3/8": 1.375, "1 1/2": 1.5]

let bolts_nominal_area: [String: Double] = ["5/8": 0.307, "3/4": 0.442, "7/8": 0.601, "1": 0.785, "1 1/8": 0.994,
                                            "1 1/4": 1.230, "1 3/8": 1.48, "1 1/2": 1.770]

let standar_nominal_hole: [String: Double] = ["1/2": 9/16, "5/8": 11/16, "3/4": 13/16, "7/8": 15/16, "1": 9/8,
                                              "1 1/8": 10/8, "1 1/4": 11/8, "1 3/8": 12/8, "1 1/2": 13/8]

let minimum_edge_distance: [String: Double] = ["1/2": 3/4, "5/8": 7/8, "3/4": 1.0, "7/8": 9/8, "1": 10/8,
                                               "1 1/8": 12/8, "1 1/4": 13/8, "1 3/8": 14/8, "1 1/2": 16/8]

let Fy_A992 = 50    // ksi
let Fu_A992 = 65    // ksi

let Fy_A572 = 50    // ksi
let Fu_A572 = 65    // ksi

let Fy_A36 = 36    // ksi
let Fu_A36 = 58    // ksi

let Es = 29000      // ksi

let plates_thickness_in: [String: Double] = ["3/16": 3/16, "1/4": 1/4, "5/16": 5/16, "3/8": 3/8, "7/16": 7/16, "1/2": 1/2,
                                             "9/16": 9/16, "5/8": 5/8, "11/16": 11/16, "3/4": 3/4, "13/16": 13/16, "7/8": 7/8,
                                             "1": 1, "1 1/8": (1+1/8), "1 1/4": (1+1/4), "1 3/8": (1+3/8), "1 1/2": (1+1/2),
                                             "1 5/8": (1+5/8), "1 3/4": (1+3/4), "1 7/8": (1+7/8), "2": 2]

let plates_weight_poundsPerSquareFoot: [String: Double] = ["3/16": 7.65, "1/4": 10.2, "5/16": 12.8, "3/8": 15.3, "7/16": 17.9, "1/2": 20.4,
                                                           "9/16": 22.9, "5/8": 25.5, "11/16": 28.1, "3/4": 30.6, "13/16": 33.2, "7/8": 35.7,
                                                           "1": 40.8, "1 1/8": 45.9, "1 1/4": 51.0, "1 3/8": 56.1, "1 1/2": 61.2,
                                                           "1 5/8": 66.3, "1 3/4": 71.4, "1 7/8": 76.5, "2": 81.6]
