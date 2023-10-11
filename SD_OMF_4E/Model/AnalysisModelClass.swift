//
//  AnalysisModelClass.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 10/11/23.
//

import SwiftUI
import Combine

class AnalysisModelClass {

    @State private var showAlert = false // State variable to control the alert's visibility
    var temp: [String] = []

    
    // MARK: - Needed Files
    
    //struct Fraction {
    //    let numerator: Int
    //    let denominator: Int
    //
    //    init?(_ string: String) {
    //        let components = string.split(separator: "/")
    //
    //        if components.count == 2,
    //           let numerator = Int(components[0]),
    //           let denominator = Int(components[1]),
    //           denominator != 0 {
    //            self.numerator = numerator
    //            self.denominator = denominator
    //        } else if let numerator = Int(string) {
    //            self.numerator = numerator
    //            self.denominator = 1
    //        } else {
    //            return nil
    //        }
    //    }
    
    struct Fraction {
        let numerator: Int
        let denominator: Int
        
        init(_ decimalValue: Double) {
            let fractionValue = decimalValue
            let tolerance = 1.0e-6
            var x = fractionValue
            var a = floor(x)
            var h1 = 1
            var k1 = 0
            var h = a
            var k = 1
            
            while x - a > tolerance * Double(k) * Double(k) {
                x = 1.0 / (x - a)
                a = floor(x)
                let h2 = h1
                h1 = Int(h)
                let k2 = k1
                k1 = k
                h = Double(Int(a) * h1 + h2)
                k = Int(a) * k1 + k2
            }
            
            self.numerator = Int(h)
            self.denominator = k
        }
    }
    
    func weldSizeFromSixteenthsToFraction(DSelectedSixteenths: Double) -> (numerator: Int, denominator: Int, DSelected: Double) {
        let DSelected = DSelectedSixteenths / 16
        let fraction = Fraction(DSelected)
        let numerator = fraction.numerator
        let denominator = fraction.denominator
        return (numerator, denominator, DSelected)
    }
    
    //
    //    var doubleValue: Double {
    //        return Double(numerator) / Double(denominator)
    //    }
    //}
    
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
    
    struct Bolt {
        enum Group: String, CaseIterable, Identifiable {
            case a_n = "A-N"
            case a_x = "A-X"
            case b_n = "B-N"
            case b_x = "B-X"
            
            var id: String { self.rawValue }
            
            var Fnt: Double {
                switch self {
                case .a_n, .a_x:
                    return 90.0
                case .b_n, .b_x:
                    return 113.0
                }
            }
            
            var Fnv: Double {
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
    
    let bolts_designation = [ 0.5 : "1/2", 0.625 : "5/8", 0.750 : "3/4", 0.875 : "7/8", 1.000 : "1", 1.125 : "1 1/8",
                              1.250 : "1 1/4" , 1.375 : "1 3/8",  1.5 : "1 1/2" ]
    
    let bolts_diameters = [ "5/8" : 0.625, "3/4" : 0.750, "7/8" : 0.875, "1" : 1.000, "1 1/8" : 1.125,
                            "1 1/4": 1.250, "1 3/8" : 1.375, "1 1/2": 1.5 ]
    
    let bolts_nominal_area = [ "5/8" : 0.307, "3/4" : 0.442, "7/8" : 0.601, "1" : 0.785, "1 1/8" : 0.994,
                               "1 1/4" : 1.230, "1 3/8" : 1.48 , "1 1/2": 1.770 ]
    
    let standar_nominal_hole: [String : Double] = ["1/2" : (9/16), "5/8": (11/16),"3/4": (13/16),"7/8" : (15/16),"1" : (9/8),
                                                   "1 1/8" : (10/8),"1 1/4" : (11/8), "1 3/8" : (12/8), "1 1/2" : (13/8)]
    
    // revisar dos ultimas cifras
    let minimum_edge_distance: [ String : Double] = ["1/2" : 3/4, "5/8" : 7/8, "3/4" : 1, "7/8" : 9/8, "1" : 10/8,
                                                     "1 1/8" : 12/8, "1 1/4": 13/8, "1 3/8": 14/8, "1 1/2" : 16/8]
    
    let plates_thickness_in: [String: Double] = ["3/16": (3/16), "1/4": (1/4), "5/16": (5/16), "3/8": (3/8), "7/16": (7/16), "1/2": (1/2),
                                                 "9/16": (9/16), "5/8": (5/8), "11/16": (11/16), "3/4": (3/4), "13/16": (13/16), "7/8": (7/8),
                                                 "1": 1.0, "1 1/8": (1+1/8), "1 1/4": (1+1/4), "1 3/8": (1+3/8), "1 1/2": (1+1/2),
                                                 "1 5/8": (1+5/8), "1 3/4": (1+3/4), "1 7/8": (1+7/8), "2": 2.0]
    
    
    
    // MARK: - Functions
    
    // Required panel zone yielding strength
    func panel_zone_yielding_strength(plasticPanelZoneDeformationsIncluded: Bool, Puc_1: Double, Fyc: Double, dc: Double, tcw: Double, bcf: Double, tcf: Double, db: Double, Ac: Double, strain_hardening_Pz: Double = 1.1, Ry: Double = 1.1, alpha: Double = 1.0) -> Double {
        
        
        temp.append("\n1. Column Panel zone yielding strength")
        
        if plasticPanelZoneDeformationsIncluded {
            temp.append("\n\tEffect of inelastic panel-zone deformation on frame stability,")
            temp.append("\twas accounted for in the analysis.")
        } else {
            temp.append("\n\tEffect of inelastic panel-zone deformation on frame stability,")
            temp.append("\twas NOT accounted for in the analysis.")
        }
        
        let Py = Fyc * Ac // ksi
        
        if plasticPanelZoneDeformationsIncluded {
            if (alpha * Puc_1 / Py) <= 0.75 {
                let Rn = 0.60 * strain_hardening_Pz * Ry * Fyc * dc * tcw * (1 + (3 * bcf * tcf * tcf) / (db * dc * tcw))
                temp.append("\t\tCase b.1, will be applied")
                return Rn
            } else {
                let Rn = 0.60 * strain_hardening_Pz * Ry * Fyc * dc * tcw * (1 + (3 * bcf * tcf * tcf) / (db * dc * tcw)) * (1.9 - 1.2 * alpha * Puc_1 / Py)
                temp.append("\t\tCase b.2, will be applied")
                return Rn
            }
        } else {
            if (alpha * Puc_1 / Py) <= 0.4 {
                let Rn = 0.60 * strain_hardening_Pz * Ry * Fyc * dc * tcw
                temp.append("\t\tCase a.1, will be applied")
                return Rn
            } else {
                let Rn = 0.60 * strain_hardening_Pz * Ry * Fyc * dc * tcw * (1.4 - Puc_1 / Py)
                temp.append("\t\tCase a.2, will be applied")
                return Rn
            }
        }
    }
    
    // Beam moment required to impart column share equal to the column panel zone
    func beam_moment_required_to_impart_column_shear_equal_to_the_column_panel_zone_strength(Vupz: Double, Vub: Double, dc: Double, Hc_ft: Double, db: Double, tbf: Double) -> Double {
        let Hc_in = Hc_ft * 12.0
        let Mub = (Vupz + Vub * dc / (4.0 * Hc_in)) / (1.0 / (db - tbf) - 1.0 / (2.0 * Hc_in))
        return Mub
    }
    
    // Round up to quarters
    func roundUpToQuarters(_ x: Double) -> (stringRepresentation: String, value: Double) {
        var whole = Int(x)
        let fraction = x - Double(whole)
        
        if fraction == 0 {
            return (String(whole), Double(whole))
        } else {
            var quarters = Int(ceil(fraction / 0.25))
            
            if quarters == 4 {
                whole += 1
                quarters = 0
            }
            
            if quarters == 0 {
                return (String(whole), Double(whole))
            } else {
                let stringRepresentation = "\(whole) \(quarters)/4"
                let value = Double(whole) + Double(quarters) / 4.0
                return (stringRepresentation, value)
            }
        }
    }
    
    func roundDownToQuarters(_ x: Double) -> (stringRepresentation: String, value: Double) {
        var whole = Int(x)
        let fraction = x - Double(whole)
        
        if fraction == 0 {
            return (String(whole), Double(whole))
        } else {
            var quarters = Int(floor(fraction / 0.25))
            
            if quarters == 4 {
                whole += 1
                quarters = 0
            }
            
            if quarters == 0 {
                return (String(whole), Double(whole))
            } else {
                let stringRepresentation = "\(whole) \(quarters)/4"
                let value = Double(whole) + Double(quarters) / 4.0
                return (stringRepresentation, value)
            }
        }
    }
    
    // Sum of bolt distances
    func sumOfBoltDistances(numberOfTopBolts: Int, db: Double, tbf: Double, pfo: Double, pfi: Double, pb: Double) -> (Sdn: Double, distances: [Double]) {
        if numberOfTopBolts == 4 {
            let h0 = (db - tbf / 2) + pfo
            let h1 = h0 - pfo - tbf - pfi
            let Sdn = h0 + h1
            return (Sdn, [h0, h1, 0.0, 0.0])
            
        } else if numberOfTopBolts == 8 {
            let h0 = (db - tbf / 2) + pfo + pb
            let h1 = h0 - pb
            let h2 = h1 - pfo - tbf - pfi
            let h3 = h2 - pb
            let Sdn = h0 + h1 + h2 + h3
            return (Sdn, [h0, h1, h2, h3])
            
        } else {
            fatalError("Invalid number of top bolts")
        }
    }
    
    
    // Design values for the selected bolts
    func designValuesForTheSelectedBolts(boltsType: String) -> (Fnt: Double, Fnv: Double, phiBolt: Double)? {
        guard let group = Bolt.Group(rawValue: boltsType) else {
            temp.append("Invalid bolt type")
            return nil
        }
        
        let phiBolt: Double = 0.75
        return (Fnt: group.Fnt, Fnv: group.Fnv, phiBolt: phiBolt)
    }
    
    
    // Bolt diameter selection
    // in accordance to commercial availability
    func selectedBoltIn(db_req: Double, bolts_designation: [Double: String]) -> (boltName: String, boltDiameter: Double)? {   // OJO  REVISAR
        if db_req <= 0.500 {
            let boltDiameter = 0.500
            let boltName = "1/2"
            return (boltName, boltDiameter)
        }
        
        if db_req > 1.5 {
            let boltDiameter = 0.0
            let boltName = "Error"
            return (boltName, boltDiameter)
        }
        
        let (m, r) = modf((db_req - 0.5) / 0.125)
        
        if r > 0 {
            let boltDiameter = 0.5 + 0.125 * (m + 1)
            let boltName = bolts_designation[boltDiameter]
            return (boltName ?? "No Available", boltDiameter)
        } else {
            let boltDiameter = 0.5 + 0.125 * m
            let boltName = bolts_designation[boltDiameter]
            return (boltName ?? "", boltDiameter)
        }
    }
    
    
    // Switch connection type for Yp
    func switchConnectionTypeForYp(
        connectionType: String,
        b_p: Double,
        S_p: Double,
        g: Double,
        de: Double,
        pb: Double,
        pfo: Double,
        pfi: Double,
        h0: Double,
        h1: Double,
        h2: Double,
        h3: Double,
        ypPlate4E: (Double, Double, Double, Double, Double, Double, Double) -> Double,
        ypPlate4ES: (Double, Double, Double, Double, Double, Double, Double, Double) -> Double,
        ypPlate8ES: (Double, Double, Double, Double, Double, Double, Double, Double, Double, Double, Double) -> Double
    ) -> Double {
        switch connectionType {
        case "4E":
            return ypPlate4E(b_p, S_p, g, pfo, pfi, h0, h1)
        case "4ES":
            return ypPlate4ES(b_p, S_p, g, de, pfo, pfi, h0, h1)
        case "8ES":
            return ypPlate8ES(b_p, S_p, g, de, pb, pfo, pfi, h0, h1, h2, h3)
        default:
            fatalError("Invalid connection type")
        }
    }
    
    // Yp value for 4E
    func ypPlate4E(b_p: Double, S_p: Double, g: Double, pfo: Double, pfi: Double, h0: Double, h1: Double) -> Double {
        var pfi = pfi
        if pfi > S_p {
            pfi = S_p
        }
        let Yp = b_p / 2 * (h1 * (1 / pfi + 1 / S_p) + h0 * (1 / pfo) - 0.5) +
        2 / g * (h1 * (pfi + S_p))
        //    temp.append("\t\tYp value: \t\t\t", Yp, "\t in")
        return Yp
    }
    
    // Yp value for 4ES
    func ypPlate4ES(b_p: Double, S_p: Double, g: Double, de: Double, pfo: Double, pfi: Double, h0: Double, h1: Double) -> Double {
        var pfi = pfi
        if pfi > S_p {
            pfi = S_p
        }
        if de < S_p {
            let Yp = b_p / 2 * (h1 * (1 / pfi + 1 / S_p) + h0 * ((1 / pfo) + 1 / (2 * S_p))) +
            2 / g * (h1 * (pfi + S_p) + h0 * (de + pfo))
            //        temp.append("\t\tYp value: \t\t\t", Yp, "\t in")
            return Yp
        } else {
            let Yp = b_p / 2 * (h1 * (1 / pfi + 1 / S_p) + h0 * ((1 / pfo) + 1 / S_p)) +
            2 / g * (h1 * (pfi + S_p) + h0 * (S_p + pfo))
            //        temp.append("\t\tYp value: \t\t\t", Yp, "\t in")
            return Yp
        }
    }
    
    // Yp value for 8ES
    func ypPlate8ES(b_p: Double, S_p: Double, g: Double, de: Double, pb: Double, pfo: Double, pfi: Double, h0: Double, h1: Double, h2: Double, h3: Double) -> Double {
        var pfi = pfi
        if pfi > S_p {
            pfi = S_p
        }
        if de < S_p {
            let Yp = b_p / 2 * (h0 / (2 * de) + h1 / pfo + h2 / pfi + h3 / S_p) +
            2 / g * (h0 * (de + pb / 4) + h1 * (pfo + 3 * pb / 4) + h2 * (pfi + pb / 4) +
                     h3 * (S_p + 3 * pb / 4) + pow(pb, 2)) + g
            //        temp.append("\t\tYp value: \t\t\t", Yp, "\t in")
            return Yp
        } else {
            let Yp = b_p / 2 * (h0 / S_p + h1 / pfo + h2 / pfi + h3 / S_p) +
            2 / g * (h0 * (S_p + pb / 4) + h1 * (pfo + 3 * pb / 4) + h2 * (pfi + pb / 4) +
                     h3 * (S_p + 3 * pb / 4) + pow(pb, 2)) + g
            //        temp.append("\t\tYp value: \t\t\t", Yp, "\t in")
            return Yp
        }
    }
    
    
    func roundUpToEighths(_ x: Double) -> (stringRepresentation: String, value: Double) {
        var whole = Int(x)
        let fraction = x - Double(whole)
        
        if fraction == 0 {
            return (String(whole), Double(whole))
        } else {
            var eighths = Int(ceil(fraction / 0.125))
            
            if eighths == 8 {
                whole += 1
                eighths = 0
            }
            
            if eighths == 0 {
                return (String(whole), Double(whole))
            } else {
                let stringRepresentation = "\(whole) \(eighths)/8"
                let value = Double(whole) + Double(eighths) / 8.0
                return (stringRepresentation, value)
            }
        }
    }
    
    // Round numbers to octaves of an inch using round or ceil
    func roundUpToSixteenths(_ x: Double) -> (stringRepresentation: String, value: Double) {
        var whole = Int(x)
        let fraction = x - Double(whole)
        
        if fraction == 0 {
            return (String(whole), Double(whole))
        } else {
            var sixteenths = Int(ceil(fraction / 0.0625))
            if sixteenths == 16 {
                whole += 1
                sixteenths = 0
            }
            
            if sixteenths == 0 {
                return (String(whole), Double(whole))
            } else {
                let stringRepresentation = "\(whole) \(sixteenths)/16"
                let value = Double(whole) + Double(sixteenths) / 16.0
                return (stringRepresentation, value)
            }
        }
    }
    
    
    // Weld size transform from sixteenths to fraction
    //func weldSizeFromSixteenthsToFraction(DSelectedSixteenths: Double) -> (numerator: Int?, denominator: Int?, DSelected: Double) {
    //    let DSelected = DSelectedSixteenths / 16
    //    let decimalObject = Decimal(DSelected)
    //    let fractionObject = Fraction(decimalObject.description)
    //    let numerator = fractionObject?.numerator
    //    let denominator = fractionObject?.denominator
    //    return (numerator, denominator, DSelected)
    //}
    
    //
    //
    //func weldSizeFromSixteenthsToFraction(DSelectedSixteenths: Double) -> (numerator: Int?, denominator: Int?, DSelected: Double) {
    //    let DSelected = DSelectedSixteenths / 16
    //    let fraction = Fraction("\(DSelected)")
    //    let numerator = fraction.numerator
    //    let denominator = fraction.denominator
    //    return (numerator, denominator, DSelected)
    //}
    
    
    
    
    // Minimum weld size verification
    func minimumWeldSizeVerification(tbw: Double, tpSelected: Double, dWShearSelected: Double) -> Double {
        let thicknessOfThinnerPartJoined = min(tbw, tpSelected)
        temp.append("\n\n\t\tNOTE:\n")
        temp.append("\t\t\t\tMinimum size of the two parts to join:\t\t\t\t\t\t\t\t\t\t\t \(thicknessOfThinnerPartJoined) in")
        
        let dWShearMin = minimumSizeOfFilletWelds(thicknessOfThinnerPartJoined)
        
        if dWShearMin > dWShearSelected {
            temp.append("\t\t\t\tUse minimum size fillet weld of:\t\t\t\t\t\t\t\t\t\t\t\t \(dWShearMin) in")
            return dWShearMin
        } else {
            temp.append("\t\t\t\tOk, fillet size exceeds the minimum size for a fillet weld:\t\t\t\t\t\t \(dWShearMin) in")
        }
        
        return dWShearSelected
    }
    
    // Maximum weld size verification
    func maximumWeldSizeVerification(tbw: Double, tpSelected: Double, dWShearSelected: Double) {
        let thicknessOfThickerPartJoined = max(tbw, tpSelected)
        temp.append("\n\t\t\t\tMaximum size of the two parts to join:\t\t\t\t\t\t\t\t\t\t\t \(thicknessOfThickerPartJoined) in")
        
        let dWShearMax = maximumSizeOfFilletWelds(thicknessOfThickerPartJoined)
        
        if dWShearSelected <= dWShearMax {
            temp.append("\t\t\t\tOk, fillet size does not exceed the maximum size for a fillet weld:\t\t\t\t \(dWShearMax) in")
        } else {
            temp.append("\tERROR, fillet size EXCEEDS the maximum size for a fillet weld: \(dWShearMax) in")
            temp.append("\t\tYou have to adjust your design!")
            
            fatalError("Crash the program")
        }
    }
    
    // Helper function to calculate the minimum size of fillet welds
    func minimumSizeOfFilletWelds(_ thickness: Double) -> Double {
        if thickness <= 0.25 {
            return 1.0 / 8.0
        } else if thickness <= 0.5 {
            return 3.0 / 16.0
        } else if thickness <= 0.75 {
            return 1.0 / 4.0
        } else {
            return 5.0 / 16.0
        }
    }
    
    // Helper function to calculate the maximum size of fillet welds
    func maximumSizeOfFilletWelds(_ thickness: Double) -> Double {
        if thickness <= 0.25 {
            return (1.0 / 4.0)
        } else {
            return (round((thickness - 1.0 / 16.0) * 100) / 100)
        }
    }
    
    
    
    // Switch column flange stiffening for Yc
    func switchColumnFlangeStiffeningForYc(
        isColumnFlangeUnstiffened: Bool,
        connectionType: String,
        c: Double,
        bcf: Double,
        S_c: Double,
        g: Double,
        pfo: Double?,
        pfi: Double?,
        pb: Double?,
        h0: Double,
        h1: Double,
        h2: Double?,
        h3: Double?,
        S_p: Double?,
        ycColumnUnstiffened4Eor4ES: (Double, Double, Double, Double, Double, Double) -> Double,
        ycColumnStiffened4Eor4ES: (Double, Double, Double, Double, Double, Double, Double) -> Double,
        ycColumnUnstiffened8ES: (Double, Double, Double, Double, Double, Double, Double, Double, Double) -> Double,
        ycColumnStiffened8ES: (Double, Double, Double, Double, Double, Double, Double, Double, Double, Double, Double) -> Double
    ) -> Double {
        
        if isColumnFlangeUnstiffened {
            if connectionType == "4E" || connectionType == "4ES" {
                return ycColumnUnstiffened4Eor4ES(c, bcf, S_c, g, h0, h1)
            } else {
                guard let pb = pb, let h2 = h2, let h3 = h3 else {
                    fatalError("Missing parameters for unstiffened 8ES")
                }
                return ycColumnUnstiffened8ES(c, bcf, S_c, g, pb, h0, h1, h2, h3)
            }
        } else {
            if connectionType == "4E" || connectionType == "4ES" {
                guard let pfo = pfo, let pfi = pfi else {
                    fatalError("Missing parameters for stiffened 4E or 4ES")
                }
                return ycColumnStiffened4Eor4ES(pfo, pfi, bcf, S_c, g, h0, h1)
            } else {
                
                guard let pfo = pfo, let pfi = pfi, let pb = pb, let h2 = h2, let h3 = h3, let S_p = S_p else {
                    fatalError("Missing parameters for stiffened 8ES")
                }
                return ycColumnStiffened8ES(pfo, pfi, bcf, S_c, g, pb, h0, h1, h2, h3, S_p)
            }
        }
    }
    
    
    // Yc value for unstiffened columns 4E & 4ES
    func ycColumnUnstiffened4Eor4ES(c: Double, bcf: Double, S_c: Double, g: Double, h0: Double, h1: Double) -> Double {
        let Yc = bcf / 2 * (h1 * (1 / S_c) + h0 * (1 / S_c)) +
        2 / g * (h1 * (S_c + 3 * c / 4) + h0 * (S_c + c / 4) + pow(c, 2) / 2) + g / 2
        
        return Yc
    }
    
    // Yc value for stiffened columns 4E & 4ES
    func ycColumnStiffened4Eor4ES(pfo: Double, pfi: Double, bcf: Double, S_c: Double, g: Double, h0: Double, h1: Double) -> Double {
        var pfi = pfi
        if pfi > S_c {
            pfi = S_c
        }
        let Yc = bcf / 2 * (h1 * (1 / S_c + 1 / pfi) + h0 * (1 / S_c + 1 / pfo)) +
        2 / g * (h1 * (S_c + pfi) + h0 * (S_c + pfo))
        
        return Yc
    }
    
    // Yc value for unstiffened 8ES
    func ycColumnUnstiffened8ES(c: Double, bcf: Double, S_c: Double, g: Double, pb: Double, h0: Double, h1: Double, h2: Double, h3: Double) -> Double {
        let Yc =
        
        bcf / 2 * ((h0 / S_c + h3 / S_c)) +
        2 / g * (h0 * (pb + c / 2 + S_c) + h1 * (pb / 2 + c / 4) + h2 * (pb / 2 + c / 2) +
                 h3 * (S_c)) + g / 2
        
        return Yc
    }
    
    // Yc value for stiffened 8ES
    func ycColumnStiffened8ES(pfo: Double, pfi: Double, bcf: Double, S_c: Double, g: Double, pb: Double, h0: Double, h1: Double, h2: Double, h3: Double, S_p: Double) -> Double {
        var pfi = pfi
        if pfi > S_p {
            pfi = S_p
        }
        let Yc = bcf / 2 * (h0 / S_c + h1 / pfo + h2 / pfi + h3 / S_c) +
        2 / g * (h0 * (S_c + pb / 4) + h1 * (pfo + 3 * pb / 4) + h2 * (pfi + pb / 4) +
                 h3 * (S_c + 3 * pb / 4) + pow(pb, 2)) + g
        
        return Yc
    }
    
    // Nearest number in a list
    func nearestValueInAList(list: [Double], targetValue: Double) -> Double {
        let closestValue = list.min(by: { abs($0 - targetValue) < abs($1 - targetValue) })
        return closestValue ?? 0.0
    }
    
    
    // Plate size finder
    func plateSize(DSelected: Double) -> (numerator: Int, denominator: Int, DSelected: Double) {
        let decimalObject = DSelected
        let fractionObject = Fraction(decimalObject)
        let numerator = fractionObject.numerator
        let denominator = fractionObject.denominator
        return (numerator, denominator, DSelected)
    }
    
    func roundDownToEighths(_ x: Double) -> (stringRepresentation: String, value: Double) {
        var whole = Int(x)
        let fraction = x - Double(whole)
        
        if fraction == 0 {
            return (String(whole), Double(whole))
        } else {
            var eighths = Int(floor(fraction / 0.125))
            
            if eighths == 8 {
                whole += 1
                eighths = 0
            }
            
            if eighths == 0 {
                return (String(whole), Double(whole))
            } else {
                let stringRepresentation = "\(whole) \(eighths)/8"
                let value = Double(whole) + Double(eighths) / 8.0
                return (stringRepresentation, value)
            }
        }
    }
    
    
    
    // MARK: - ERROR ALERT
    
//// Function to create and display the alert
//
//    // This must be in the view where the model is going to be executed
//    struct YourView: View {
//        @State private var showAlert = false
//        @State private var alertTitle = "Alert Title"
//        @State private var alertMessage = "Alert Message"
//
//        var body: some View {
//            Text("Hello, World!")
//                .onAppear {
//                    // Call the function to show the alert when the view appears
//                    showMyAlert(title: "Custom Alert", message: "This is a custom message alert.")
//                }
//                .alert(isPresented: $showAlert) {
//                    Alert(
//                        title: Text(alertTitle),
//                        message: Text(alertMessage),
//                        primaryButton: .default(Text("OK")) {
//                            // Handle the user's action when they tap the OK button
//                            showAlert = false // Dismiss the alert
//                        },
//                        secondaryButton: .cancel() {
//                            // Handle the user's action when they tap the Cancel button (if needed)
//                            showAlert = false // Dismiss the alert
//                        }
//                    )
//                }
//        }
//
//        func showMyAlert(title: String, message: String) {
//            alertTitle = title
//            alertMessage = message
//            showAlert = true
//        }
//    }
    
    
    // OJO     OJO
    
    /*
     If you have a separate model with a complex procedure that needs to trigger an alert in your YourView SwiftUI view, you can achieve this by creating a binding between your model and your view. Here's how you can do it:

     Create a ViewModel: Start by creating a ViewModel that serves as an intermediary between your model and your view. The ViewModel will include a @Published property to indicate when an alert should be shown.
     
     
         import Combine

         class ViewModel: ObservableObject {
             @Published var showAlert = false
             var alertTitle = ""
             var alertMessage = ""
     

     // Function to create and display the alert
     
             func showMyAlert(title: String, message: String) {
                 alertTitle = title
                 alertMessage = message
                 showAlert = true
             }
         }

     
     Use the ViewModel in YourView: In your YourView, create an instance of the ViewModel, and use it to bind to the alert presentation.
     
         import SwiftUI

         struct YourView: View {
             @StateObject private var viewModel = ViewModel()

             var body: some View {
                 Text("Hello, World!")
                     .onAppear {
                         // Call the function in the ViewModel to show the alert when the view appears
                         viewModel.showMyAlert(title: "Custom Alert", message: "This is a custom message alert.")
                     }
                     .alert(isPresented: $viewModel.showAlert) {
                         Alert(
                             title: Text(viewModel.alertTitle),
                             message: Text(viewModel.alertMessage),
                             primaryButton: .default(Text("OK")) {
                                 // Handle the user's action when they tap the OK button
                                 viewModel.showAlert = false // Dismiss the alert
                             },
                             secondaryButton: .cancel() {
                                 // Handle the user's action when they tap the Cancel button (if needed)
                                 viewModel.showAlert = false // Dismiss the alert
                             }
                         )
                     }
             }
         }

     
     Model Interaction: In your model, you can create an instance of the ViewModel and interact with it to trigger alerts when needed.
     
         class YourModel {
             let viewModel: ViewModel

             init(viewModel: ViewModel) {
                 self.viewModel = viewModel
             }

             func doSomething() {
                 // Your model's logic here
                 // When you need to show an alert, call the ViewModel's function
                 viewModel.showMyAlert(title: "Alert from Model", message: "This is a model-triggered alert.")
             }
         }
     
     
     In Your App Entry Point (YourApp): Create the ViewModel and inject it into both your YourView and your model.
     
         @main
         struct YourApp: App {
             var body: some Scene {
                 WindowGroup {
                     let viewModel = ViewModel()
                     let model = YourModel(viewModel: viewModel)
                     YourView()
                         .environmentObject(viewModel)
                     // You can also pass the viewModel to your model if necessary
                 }
             }
         }


     By following these steps, you establish communication between your model, ViewModel, and view, allowing your model to trigger alerts that are presented in your SwiftUI view.
     
     */

    
    // MARK: - Stop the model inside of a function

    /*
     
     In SwiftUI and Swift, you can stop the execution of a function or process without crashing the program by using the return statement. The return statement is used to exit the current function or closure and return control to the caller. This is a controlled way to exit a function and doesn't cause a crash.

     Here's an example of how you can use the return statement to stop the execution of a function:
     
     
         func processSomething() {
             // Perform some tasks
             if someCondition {
                 // If a condition is met, exit the function using return
                 return
             }

             // Continue with other tasks
         }
     
     
     In the example above, if the someCondition is met, the return statement is executed, and the function processSomething will exit immediately without causing a crash.

     Keep in mind that using return to exit a function is a common and appropriate way to handle various situations, such as condition checks or early exits, and it doesn't lead to program crashes when used properly.

     */
    
    
    
    // MARK: -  GOLBAL LOCAL VARIABLES
    
    func connectionDesign () {
        
        // Steel Data
        let Es = 29000.0      // ksi
        
        // examples
        let answer = "yes"              // OJO
        
        // Analysis
        let second_order_effects = true
        let direct_analysis_method = true
        var plastic_panel_zone_deformations_included = true
        
        // Steel Design
        var is_column_strong_enough = true
        var is_column_flange_unstiffened = true
        var continuity_plates = false
        
        // Type of connection
        let connection_type = "4E"
        let numberOfTopBolts = 4            // OJO 8ES
        
        // Data Input
        var top_column_connection = true
        var top_column_distance = 2.54
        
        /*
         # Original Data
         #    S = 20     # psf
         #    D = 15     # psf
         
         #    Risk_Category           = 'II'
         #    Seismic_Design_Category = "D"
         #    R                       = 3.5
         #    omega_cero              = 3.0
         #    Cd                      = 3.0
         #    Ie                      = 1.00
         Sds                     = 0.528
         #    rho                     = 1.0
         */
        
        let Sds = 0.528
        
        
        // MARK: - CONNECTION DESIGN
        
        let beam = "W18X40"
        let column = "W12X50"
        
        // Beam Design Parameters
        
        let aisc_manual_label_b = "W18X40"
        let db  =     17.9
        let tbw =     0.315
        let bbf =     6.02
        let tbf =     0.525
        let Zxb =     78.4
        let wgb =     3.5
        
        temp.append("\nBeam Design Parameters:")
        temp.append("\n\tAISC Manual Label = \(aisc_manual_label_b)")
        temp.append("\tdb  = \t\t\(db)\t in")
        temp.append("\ttbw = \t\t\(tbw)\t in")
        temp.append("\tbbf = \t\t\(bbf)\t in")
        temp.append("\ttbf = \t\t\(tbf)\t in")
        temp.append("\tZxb = \t\t\(Zxb)\t in3")
        temp.append("\twgb = \t\t\(wgb)\t in")
        
        // Column Design Parameters
        
        let aisc_manual_label_c = "W12X50"
        let Ac  =        14.6
        let dc =         12.2
        let tcw =         0.370
        let bcf =         8.08
        let tcf =         0.640
        let kdes_c =      1.14
        let kdet_c =      1.5
        let k1_c =        0.9375
        let Zxc =        71.9
        let h_twc =      26.8
        let wgc =         5.5
        
        temp.append("\nColumn Design Parameters:")
        temp.append("\n\tAISC Manual Label = \(aisc_manual_label_c)")
        temp.append("\tAc     = \t\(Ac)\t in2")
        temp.append("\tdc     = \t\(dc)\t in")
        temp.append("\ttcw    = \t\(tcw)\t in")
        temp.append("\tbcf    = \t\(bcf)\t in")
        temp.append("\ttcf    = \t\(tcf)\t in")
        temp.append("\tkdes_c = \t\(kdes_c)\t in")
        temp.append("\tkdet_c = \t\(kdet_c)\t\t in")
        temp.append("\tk1_c   = \t\(k1_c)\t in")
        temp.append("\tZxc    = \t\(Zxc)\t in3")
        temp.append("\th_twc  = \t\(h_twc)")
        temp.append("\twgc    = \t\(wgc)\t\t in")
        
        
        // Column Data
        
        let Fyc = ASTM.Specification.a572.Fy
        let Fuc = ASTM.Specification.a572.Fu
        let Hc_ft = 17.0
        
        // Beam Data
        
        let Fyb = ASTM.Specification.a572.Fy
        let Fub = ASTM.Specification.a572.Fu
        let Lb_ft = 30.0
        
        // end_plate_specification = 'A572'
        
        let Fy_p = ASTM.Specification.a572.Fy
        let Fu_p = ASTM.Specification.a572.Fu
        
        // continuity_plate_specification = 'A572'
        
        let Fycp = ASTM.Specification.a572.Fy
        let Fucp = ASTM.Specification.a572.Fu
        
        // botls
        let bolts_type = "A-N"
        var Fnt        : Double
        var Fnv        : Double
        var phi_bolt   : Double
        
        
        // Column required strenght
        
        let Puc_1   = 15.4
        let Vuc     = 3.91
        let Muc_top = 66.4
        let Muc_bot =  0.0
        
        
        temp.append("\nColumn required strenght LRFD:")
        temp.append("\n\t\t\t\tColumn Axial Load\t\t\t\t\t\t\tPu:\t" + "\(Puc_1)" + " kips")
        temp.append("\t\t\t\tColumn Top Moment Load\t\t\t\t\tMu_top:\t" + "\( Muc_top)" +  " kips-ft")
        temp.append("\t\t\t\tColumn Bottom Moment Load\t\t\t\tMu_bot:\t" + "\( Muc_bot)" +  "  kips-ft")
        temp.append("\t\t\t\tColumn Shear Load\t\t\t\t\t\t\tVu:\t" + "\( Vuc)" + " kips\n")
        
        let Puc_2 = 21.1
        
        
        temp.append("\nColumn Maximun Required Strength, from aplified seismic loads \nand overstrength factor:")
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tPUc_2:\t" + "\( Puc_2)" +  " kips\n\n")
        
        let Pub        =  1.72       // kips
        let Mub_end__1 =  37.2       // kips-ft
        let Mub_end__2 = -78.3       // kips-ft
        let Vub        =  9.17       // kips        UNICO de interes para la Design Guide N. 4
        
        
        temp.append("Beam required strenght LRFD:")
        temp.append("\n\t\t\t\tBeam Axial Load\t\t\t\t\t\t\t\tPu:\t" + "\( Pub)" +  " kips")
        temp.append("\t\t\t\tBeam Top Moment Load\t\t\t\t\tMu_top:\t" + "\( Mub_end__1)" +  " kips-ft")
        temp.append("\t\t\t\tBeam Bottom Moment Load\t\t\t\t\tMu_bot:\t" + "\( Mub_end__2)" +  " kips-ft")
        temp.append("\t\t\t\tBeam Shear Load\t\t\t\t\t\t\t\tVu:\t" + "\( Vub)" + " kips\n")
        
        
        let VD = 3.38    // kips
        let VL = 0.0     // kips
        let VS = 4.50    // kips
        
        // VEv = 0.2 Sds D   Where D means the dead load under consideration
        let VEv = round((0.2 * Sds * VD) * 1000)/1000
        
        
        temp.append("\nOther Shear forces at the beam end simultaneously with Emh:\n")
        temp.append("\t\t\t\tShear force due to Dead Load\t\t\t\tVD:\t" + "\( VD)" +  "\tkips")
        temp.append("\t\t\t\tShear force due to Live Load\t\t\t\tVL:\t" + "\( VL)" +  "\tkips")
        temp.append("\t\t\t\tShear force due to Snow Load\t\t\t\tVS:\t" + "\( VS)" +  "\tkips")
        temp.append("\t\t\t\tEfect of vertical Seismic forces\t\t   VEv:\t" + "\( VEv)" +  "\tkips")
        
        
        //func calculateStrength(Fyb: Double, Zxb: Double, Fyc: Double, Zxc: Double, answer: String, Puc_1: Double, dc: Double, tcw: Double, bcf: Double, tcf: Double, db: Double, Ac: Double, Vub: Double, Hc_ft: Double, tbf: Double, Lb_ft: Double, Sds: Double, VD: Double, VL: Double, VS: Double) {
        //
        // Beam W18x40
        let Ryb = 1.1
        let Mpb = round(Fyb * Zxb)
        let Mpb_exp = round(1.1 * 1.1 * Mpb / 10) * 10
        
        
        temp.append("\n\nBeam expected flexural strength:")
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\tMpb:\t" + "\( Mpb)" +  "kips-in")
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\tMpb_exp:\t" + "\( Mpb_exp)" +  "kips-in")
        
        // Column W12x35
        let Ryc = 1.1
        let Mpc = round(Fyc * Zxc)
        let Mpc_exp = round(1.1 * Ryc * Mpc)
        
        temp.append("\n\nColumn expected flexural strength:")
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\tMpc:\t" + "\( Mpc)" +  "kips-in")
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\tMpc_exp:\t" + "\( Mpc_exp)" +  "kips-in\n\n")
        
        
        // MARK: - NEED TO BE SOLVED
/*
    if answer.lowercased() != "yes" {
        let answer_2 = readLine() ?? ""
        if answer_2.lowercased() != "yes" {
            plastic_panel_zone_deformations_included = false
            temp.append("\n\n\tPlastic panel zone deformations were NOT included in the analysis\n\n")
        } else {
            temp.append("\n\n\tPlastic panel zone deformations were included in the analysis\n\n")
        }
    } else {
        temp.append("\n\n\tPlastic panel zone deformations were included in the analysis\n\n")
    }
*/
        let Rn = panel_zone_yielding_strength(plasticPanelZoneDeformationsIncluded: plastic_panel_zone_deformations_included, Puc_1: Puc_1, Fyc: Fyc, dc: dc, tcw: tcw, bcf: bcf, tcf: tcf, db: db, Ac: Ac, strain_hardening_Pz: 1.1, Ry:  1.1, alpha: 1.0)
        let Vpz = round(Rn)
        let alpha_s = 1.0   // force level of adjustment factor LFRD
        let Vu_pz = Vpz / alpha_s
        var Mub = beam_moment_required_to_impart_column_shear_equal_to_the_column_panel_zone_strength(Vupz: Vu_pz, Vub: Vub, dc: dc, Hc_ft: Hc_ft, db: db, tbf: tbf)
        Mub = round(Mub)
        
        
        temp.append("\n\nColumn Panel-Zone Evaluation:\n")
        temp.append("\tUsing the requiered axial strength of the column from analysis\t\tPu:\t" + "\( Puc_1)" +  "  kips")
        
        temp.append("\nInitial Column panel zone values:\n")
        temp.append("\tForce transfered to the connection due the panel zone yielding\t\tVpz:\t" + "\( Vpz)" +  " kips")
        
        temp.append("\tColumn panel zone shear\t\t\t\t\t\t\t\t\t\t\t\tVu_pz:\t" + "\( Vu_pz)" +  " kips")
        
        temp.append("\n\tBeam moment required to impart column shear equal to the \n\tcolumn panel zone strength \t\t\t\t\t\t\t\t\t\t\tMub: \t" + "\( Mub)" +  "kips-in\n")
        
        temp.append("\n\tMaximum force that can be delivered by the system to the")
        temp.append("\tconnection, is the minimum of the three previous values")
        
        let Mp_design = min(Mub, Mpc_exp, Mpb_exp)
        temp.append("\n\tMaximum flexural Moment deliered by the system:  \t\t\t\t\tMp_design:\t" + "\(Mp_design)" +  "kips-in")
        
        Mub = Mp_design
        temp.append("\tRequired flexural strength \t\t\t\t\t\t\t\t\t\t\tMub : \t\t" + "\( Mub)" +  "kips-in\n\n")
        
        
        let Lb_in = Lb_ft * 12     // in
        let Lcf = round(Lb_in - dc)
        let V_Emh = round(2 * Mub / Lcf * 10) / 10
        let Vu_LC_6 = round(((1.2  + 0.2 * Sds) * VD + V_Emh + 0.5 * VL + 0.2 * VS ) * 10) / 10
        var Vu = max(V_Emh, Vu_LC_6)
        //}
        
        
        temp.append("\n\nClear distance of the beam from Fange to flange of the columns ")
        
        // Beam length from feet to inches
        // Lb_in = Lb_ft * 12     // in
        temp.append("\n\tBeam length node to node: \t\t\t\t\t\t\t\t\t\t\tLb:\t\t" + "\( Lb_in)" +  " in")
        
        // Clear length of the beam from flange to flange of columns
        //Lcf = round(Lb_in - dc)      // in
        temp.append("\tClear length of the beam from flange to flange of columns\t\t\tLcf:\t" + "\( Lcf)" +  " in\n")
        
        
        temp.append("\n\nMaximum Shear Force")
        
        //V_Emh = round(2 * Mub / Lcf)
        
        temp.append("\n\tBeam Shear at the beam-column-face,  \t\t\t\t Shear due to V_Emh:\t" + "\( V_Emh)" +  " kips")
        temp.append("\n\tControling load combination from ASCE/SEI 7 is")
        
        //Vu_LC_6 = round((1.2  + 0.2 * Sds) * VD + V_Emh + 0.5 * VL + 0.2 * VS)
        temp.append("\t\t\t\tShear due horizontal forces including overstrength\t\tEmh:\t" + "\( Vu_LC_6)" +  " kips")
        
        // Design Shear Force will the maximum of V_Emh and Vu_LC_6
        
        temp.append("\n\n\tMaximum Shear force, the maximun of the Vu_LC and VEmh")
        
        Vu = max(V_Emh, Vu_LC_6)
        temp.append("\t\t\t\t\t\t\t\t\tMaximum Shear force of design\t\t Vu:\t" + "\( Vu)" +  "  kips\n")
        
        
        // End Plate configuration
        
        temp.append("\n\nConnection Details for the " + "\(connection_type)" + " END-PLATE: \n\n")
        
        // End Plate configuration Data
        
        
        var de  = 1.5  // in
        var pfo = 2.0  // in
        var pfi = 2.0  // in
        var g   = 4.5  // in
        var pb  = 0.0  // in
        
        
        // Check maximum bolt gage
        
        var g_min = min((min(pfo, pfi) * 2), wgc)
        var g_name: String = ""
        
        if (g < g_min) {
            g = g_min
            
            (g_name , g) = roundUpToQuarters(g)
            temp.append("\n\t\tWARNING!!\n\t\tBolt gage can NOT be smaller than the space needed to place the bolts.")
            temp.append("\t\tThe value was changed to:', g,' in which is: " + "\( g_name)" +  "  in \n\n")
        }
        
        // Check minimum bolt gage
        else if (g > bbf){
            (g_name , g) = roundDownToQuarters(bbf)
            temp.append("\n\t\tWARNING!!\n\t\tBolt gage can NOT be larger the Beam Flange.")
            temp.append("\t\tThe value was changed to:" + "\( g)" + " in which is: " + "\(g_name)" +  "  in \n")
        }
        
        temp.append("\tEdge distance \t\t\t\t\t\t\t\t\t\t\t\t\t\t de: \t" + "\( de)" +  " in")
        temp.append("\tBeam Flange to Top Bolts Distance \t\t\t\t\t\t\t\t\t pfo: \t" + "\( pfo)" +  " in")
        temp.append("\tBeam Flange to Bottom Bolts Distance \t\t\t\t\t\t\t\t pfi: \t" + "\( pfi)" +  " in")
        temp.append("\tWorkable Gage \t\t\t\t\t\t\t\t\t\t\t\t\t\t g: \t" + "\( g)" +  " in")
        
        
        // Determine Bolt Diameter
        // AISC Design Guide 4, Equation 3.6
        
        temp.append("\n\n\tBolt Details:")
        
        temp.append("\n\t\t Number of Top Bolts :\t\t\t\t\t\t\t\t\t\t\t\t\t \(numberOfTopBolts)  \tBolts")
        
        // compute Sdn, error, h0, h1, h2, h3
        
        var Sdn: Double
        var h: [Double] = [0.0, 0.0, 0.0, 0.0] // Initialize the h array with default values
        //var h1: Double
        //var h2: Double
        //var h3: Double
        //var h4: Double
        
        if numberOfTopBolts == 4 {
            
            (Sdn, h) = sumOfBoltDistances(numberOfTopBolts: numberOfTopBolts, db: db, tbf: tbf, pfo: pfo, pfi: pfi, pb: pb )
            Sdn = round(Sdn * 10) / 10
            h[0] = round(h[0] * 10) / 10
            h[1] = round(h[1] * 10) / 10
            //    h[2] = 0.0
            //    h[3] = 0.0
            
            temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t Sdn:\t" + "\( Sdn)" +  " \tin\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ho:\t" + "\(h[0]))" +  " \tin\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t h1:\t" + "\( h[1])" + " \tin")
        } else{
            (Sdn, h) = sumOfBoltDistances(numberOfTopBolts: numberOfTopBolts, db: db, tbf: tbf, pfo: pfo, pfi: pfi, pb: pb )
            Sdn = round(Sdn * 10)/10
            h[0] = round(h[0] * 10)/10
            h[1] = round(h[1] * 10)/10
            h[2] = round(h[2] * 10)/10
            h[3] = round(h[3] * 10)/10
            
            temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t Sdn:\t" + "\( Sdn )" +  " \tin\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ho:\t" + "\( h[0])" +  "\tin\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t h1:\t" + "\( h[1])" + " \tin")
            temp.append("\tin\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t h3:\t" + "\( h[2])" +  "\tin\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t h4:\t" + "\( h[3])" + " \tin")
        }
        
        // get the values for the bolt type
        (Fnt, Fnv, phi_bolt) = designValuesForTheSelectedBolts(boltsType: bolts_type) ?? (90.0, 54.0, 0.75)
        
        temp.append("\n\t\tBolt Selected:  \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" + "\( bolts_type)" +
              "\n\t\t\t Nominal Tensie Strength of the bolt \t\t\t\t\t\tFnt:\t\t" + "\( Fnt)" +  "  kips" +
              "\n\t\t\t Nominal Shear Strength of the bolt \t\t\t\t\t\tFnv:\t\t" + "\( Fnv)" +  "  kips" +
              "\n\t\t\t \t\t\t\t\t\t\t\t\t\t\t\t\t\tphi_bolt:  \t\t" + "\( phi_bolt)" )
        
/*
# check for stiffened connections
if (connection_type == "4ES" or connection_type == "8ES"):
    
    lp = 11.5        # Lst + lp
    Mub = Mub + Vbu * lp
*/
        
        // Compute the requiered bolt diameter
        
        let db_req = round(sqrt( 2 * Mub / (Double.pi * phi_bolt * Fnt * Sdn)) * 1000) / 1000
        
        temp.append("\n\t\t\tRequired bolt diameter: \t\t\t\t\t\t\t\t\t\t\t\t" + "\(  db_req )" +  "   in")
        
        var bolt_name: String
        var bolt_diameter_selected: Double
        //var A_bolt: Double
        
        let bolt_selected = selectedBoltIn(db_req: db_req, bolts_designation: bolts_designation)
        (bolt_name, bolt_diameter_selected) = bolt_selected!
        
        temp.append("\n\t\t\tComputed comercial bolt caracteristics to be used:\n")
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\tBolt selected:")
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tname: \t\t\t" + "\(  bolt_name )" + "   \tin" + "\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tDiameter: \t\t" + "\( bolt_diameter_selected )" +  " \tin")
        
        
        //// Assuming you have a value for db_req
        //let db_req = 0.75
        
        var A_bolt: Double = 0.0 // Declare A_bolt variable outside the if block
        
        if let bolt_selected = selectedBoltIn(db_req: db_req, bolts_designation: bolts_designation) {
            bolt_name = bolt_selected.boltName
            bolt_diameter_selected = bolt_selected.boltDiameter
            
            if let selectedArea = bolts_nominal_area[bolt_name] {
                A_bolt = selectedArea // Update the value of A_bolt
                //        temp.append("Selected Bolt Name: \(bolt_name)")
                //        temp.append("Selected Bolt Diameter: \(bolt_diameter_selected)")
                //        temp.append("Selected Bolt Nominal Area: \(A_bolt)")
            } else {
                temp.append("Bolt name not found in the nominal area dictionary.")
            }
        } else {
            temp.append("No bolt selected or error occurred.")
        }
        
        // You can now use A_bolt variable outside the if block
        // For example:
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tBolt Area:\t\t \(A_bolt)  in2")
        
        
        
        
        
        // Calculate Mp based on the selected bolt
        temp.append("\n\nCalculate Mp based on the selected bolt")
        let Pt_bolt = round(Fnt * A_bolt * 10) / 10
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tPt: \t\t" + "\(  Pt_bolt )" +  "   kips")
        
        let Mnp = round(( 2 * Pt_bolt * Sdn) * 100) / 100
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tMnp:\t\t" + "\(  Mnp )" +  " kips-in")
        
        let phi_Mnp = round(phi_bolt * Mnp)
        
        temp.append("\n\tFrom the AISC Design Guide 4 equation 3.7")
        temp.append("\tFlexural Design Strength of the connection \n\tfor bolt rupture without prying:")
        
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tɸ Mnp: \t\t" + "\(  phi_Mnp )" + " kips-in\n")
        
        
        
        if phi_Mnp >= Mub {
            temp.append("\n\tThe selected bolts are OK.")
            temp.append("\n\t\tThe Capacity Moment    \t\t\t\t\t\t\t\t\t\t\t ɸMpn: \t\t" + "\(  phi_Mnp )" +  " kips-in,")
            temp.append("\t\tis larger than the Maximun Moment   \t\t\t\t\t\t\t  Mub: \t\t" + "\(  Mub )" + " kips-in, \n\t\tdeleverd by the system to the connection\n")
            
            
        } else {
            temp.append("\n\t\t WARNING: //n/t/tThe selected bolts are NOT ok.")
            temp.append("\\t\tThe Capacity Moment: " + "\(  phi_Mnp )" +  "kips-in is smaller than the Maximun Moment: " + "\(  Mp_design )" + " kips-in \n\t\tdeleverd by the system to the connection\n")
            
            temp.append("\nProgram now will crash for you to restart process \nand select a new configuration: \n")
            //    1/0   // to crash the prorgam
        }
        
        // End Plate width
        // We follw the convention of adding one inch to the width of the beam flange.
        // It can not be less than the beam flange width
        
        temp.append("\n\nEnd Plate Width & Thickness\n")
        
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t Considering phi_Mnp: \t\t" + "\(  phi_Mnp )" +  " kips-in\n")
        // Phi bending
        let phi_b = 0.9
        
        // From Table 3.1 AISC Design Guide 4
        let b_p = round((bbf + 1))
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t End-Plate width: \t\t" + "\(  b_p )" +  "\t in")
        
        let S_p = round(0.5 * sqrt(b_p * g) * 100) / 100
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t S value: \t\t" + "\(  S_p )" +  "\t in")
        
        
        // Rest of your code remains unchanged
        
        var Yp = switchConnectionTypeForYp(
            connectionType: connection_type,
            b_p: b_p,
            S_p: S_p,
            g: g,
            de: de,
            pb: pb,
            pfo: pfo,
            pfi: pfi,
            h0: h[0],
            h1: h[1],
            h2: h[2] ,
            h3: h[3] ,
            ypPlate4E: ypPlate4E,
            ypPlate4ES: ypPlate4ES,
            ypPlate8ES: ypPlate8ES
        )
        
        Yp = round(Yp)
        
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tYp value: \t\t" + "\(  Yp )" +  "\t in")
        
        
        
        
        // From Equation 3.10 Design Guide 4
        let tp_req = round(sqrt((1.11 * phi_Mnp)/( phi_b * Fy_p * Yp)) * 1000) / 1000
        var string_representation: String = ""
        var tp_selected: Double = 0.0
        
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\tRequired End Plate Thickness: \t\t" + "\(  tp_req )" +  "  in")
        (string_representation, tp_selected) = roundUpToEighths(tp_req)
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\tAssigned End Plate Thickness:  \t\t" + "\(  tp_selected )" +  "\tin, equal to: \t" + "\(  string_representation )" +  " in\n")
        
        
        
        var tst_selected: Double = 0.0
        var lst_selected: Double = 0.0
        var hst: Double = 0.0
        
        if (connection_type == "4ES" || connection_type == "8ES") {
            
            temp.append("End-Plate Stiffener Design")
            
            temp.append("\n\nSize end plate stiffener")
            temp.append("\n\tMatch the Stiffener Strength to the beam web strength")
            
            let tst_req = round(tbw * (Fyb / Fy_p) * 1000) / 1000
            temp.append("\n\t\tEnd-plate Stiffener thickness required tst_req: \t" + "\( tst_req)")
            
            (string_representation, tst_selected) = roundUpToSixteenths(tst_req)
            temp.append("\t\tEnd-plate Stiffener thickness selected tst_selected: \t" + "\(  tst_selected )" +  " in, " + "\(  string_representation )" +  "  in")
            
            hst = pfo + pb + de
            temp.append("\n\t\tHeight of the stiffener hst: " + "\(  hst )" +  "  in")
            
            let angle_radians = Double.pi / 6.0
            let lst_req = hst / tan(angle_radians)
            (string_representation, lst_selected) = roundUpToSixteenths(lst_req)
            temp.append("\n\t\tEnd-plate Stiffener length selected lst_selected: " + "\(  lst_selected )" +  " in")
            
            let _lambda = round( hst / tst_selected * 1000) / 1000
            
            let _lambda_r = round( 0.56 * sqrt(Es / Fy_p) * 1000) / 1000
            
            if _lambda < _lambda_r {
                temp.append("\n\n\tStiffener is not subject to local buckling: \n\n\t\tlambda: " + "\(  _lambda )" +  ", is less than lambda_r: " + "\( _lambda_r )" + "\n\n")
            } else{
                temp.append("Warning:\n\t\tStiffener IS subject to local buckling!")
                temp.append("Select a larger stiffness of the stiffener")
                temp.append("Now the program will crash")
                //          0/1
            }
            
        } else {
            temp.append("")
        }
        
        
        // temp.append OJO OJO OJO Falta terminar
        
        // tst_selected = 7/16
        
        var w_stiff_tensile_numerator: Int = 0
        var w_stiff_tensile_denominator: Int = 0
        var w_stiff_tensile_selected: Double = 0.0
        
        // Stiffener end-plate weld
        if (connection_type == "4ES" || connection_type == "8ES"){
            
            if tst_selected >= 0.375{
                temp.append("\n\nStiffener to end-plate weld:")
                temp.append("\n\t\tWeld the Stiffener Plate to the end-plate using a complete-join-penetration groove weld\n\n")
            } else {
                temp.append("\n\nStiffeners plate weld to end-plate")
                
                let phi_t = 0.9
                let phi_w = 0.75
                
                let phi_stiff_tensile = round(phi_t * Fy_p * tst_selected * hst * 10) / 10       // kips / in
                
                let w_stiff_tensile_req_sixteenths =  round(phi_t * phi_stiff_tensile / ( 2 * 1.392 * 1.5 * hst) * 1000) / 1000
                temp.append("\n\tRequired weld size in sixteenths of an inch, w_stiff_tensile_req_sixteenths:\t  " + "\(w_stiff_tensile_req_sixteenths )" +  "  sixteenths")
                
                let w_stiff_tensile_selected_sixteenths = ceil(w_stiff_tensile_req_sixteenths)
                temp.append("\tSelected weld size in sixteenths of an inch, w_stiff_tensile_selected_sixteenths: " + "\( w_stiff_tensile_selected_sixteenths )" +  "    sixteenths")
                
                (w_stiff_tensile_numerator, w_stiff_tensile_denominator, w_stiff_tensile_selected) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: w_stiff_tensile_selected_sixteenths)
                temp.append("\tUse two fillet welds (Two-sided) to weld the stiffeners plates to the end-plate:   \(String(describing: w_stiff_tensile_numerator)) / \(String(describing: w_stiff_tensile_denominator))    in = \(w_stiff_tensile_selected)  in  ")
                
                w_stiff_tensile_selected = minimumWeldSizeVerification(tbw: tst_selected, tpSelected: tp_selected, dWShearSelected: w_stiff_tensile_selected)
                maximumWeldSizeVerification(tbw: tst_selected, tpSelected: tp_selected, dWShearSelected: w_stiff_tensile_selected)
                
                temp.append("\n\n")
            }
        } else {
            temp.append("")
        }
        
        
//        var w_stiff_shear_req: Double = 0.0
//        var w_stiff_shear_req_sixteenths: Double = 0.0
        
        var w_stiff_shear_numerator: Int = 0
        var w_stiff_shear_denominator: Int = 0
        var w_stiff_shear_selected: Double = 0.0
        
        // REVISAR !!!
        // two sided filet weld calculate the required leg
        
        if (connection_type == "4ES" || connection_type == "8ES") {
            
            // Stiffener beam flange weld
            
            temp.append("\n\nShear yield of strength of the stiffener plate")
            
            let Vn_st = round(0.60 * Fy_p * tst_selected * 100) / 100
            temp.append("\n\t\tShear yield strength of the stiffener plate Vn_st: " + "\(  Vn_st )" +  "  kips/in")
            
            temp.append("\n\nFor a two sided filet weld calculate the required leg size w_req by setting the available")
            temp.append("shear yield strength of the plate equal to the available shear strength of the weld")
            temp.append("and solving for w_req")
            
            temp.append("\n\nStiffeners plate weld to beam flange")
            
            let phi_v = 1.0
            let phi_w = 0.75
            
            let w_stiff_shear_req = (round( phi_v * Vn_st / ( 2 * phi_w * 0.60 * 70 / sqrt(2)) * 1000) / 1000)
            
            let w_stiff_shear_req_sixteenths =  (round(phi_v * Vn_st / ( 2 * 1.392) * 1000) / 1000)
            temp.append("\n\tRequired weld size in sixteenths of an inch, w_stiff_shear_req_sixteenths:\t  " + "\( w_stiff_shear_req_sixteenths )" +  "  sixteenths")
            
            let w_stiff_shear_selected_sixteenths = ceil(w_stiff_shear_req_sixteenths)
            temp.append("\tSelected weld size in sixteenths of an inch, w_stiff_shear_selected_sixteenths:\t  " + "\( w_stiff_shear_selected_sixteenths )" +  "    sixteenths")
            
            (w_stiff_shear_numerator, w_stiff_shear_denominator, w_stiff_shear_selected) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: w_stiff_shear_selected_sixteenths)
            temp.append("\tUse two fillet welds (Two-sided) to weld the stiffeners plates to beam flange:     \(String(describing: w_stiff_shear_numerator)) / \(String(describing: w_stiff_shear_denominator))     in = \(w_stiff_shear_selected) in")
            
            w_stiff_shear_selected = minimumWeldSizeVerification(tbw: tbf, tpSelected: tst_selected, dWShearSelected: w_stiff_shear_selected)
            maximumWeldSizeVerification(tbw: tbf, tpSelected: tst_selected, dWShearSelected: w_stiff_shear_selected)
            
            //    temp.append("\n\n")
            
        } else {
            temp.append("")
        }
        
        
        temp.append("Check end-plate bolts for beam shear transfer")
        
        // In accordance to the ASIC Design Guide,
        // we will asume that only the bolts at the compresion flange will transfer the shear loads.
        
        // From AISC Manual Table 7-1 for Bolt Group A-N Loading S and diameter = 1.0 in
        
        let phi_rn_bolt = round(phi_bolt * Fnv * A_bolt * 10) / 10
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t  phi_rn:  \t\t" + "\(  phi_rn_bolt )" +  "   kips")
        
        // Considering the number of top bolts
        let phi_Vn_bolts = round(Double(numberOfTopBolts) * phi_rn_bolt)
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tphi_Vn_bolts: \t\t" + "\(  phi_Vn_bolts )" +  "   kips")
        
        if phi_Vn_bolts >= Vu {
            temp.append("\n\n\tOK. Bolts can carry the maximum shear,")
            temp.append("\t\tbecause   \tphi_Vn: " + "\(  phi_Vn_bolts )" +  "  kips, \n\t\tis larger than  Vu:  " + "\( Vu )" + "  kips.\n")
        } else {
            temp.append("\n\t\tPlease, enlarge the bolt's diameter")
            temp.append("\nProgram now will crash for you to restart process \nand select a new configuration: \n")
            
            //1/0   # to crash the prorgam       OJO !!!
        }
        
        
        
        
        // Nominal bearing strength of a single bolt when deformation at the bolt hole at service load is a consideration
        
        temp.append("\nCheck bolt bearing and tearout per AISC Specification Section J3.10")
        temp.append("\n\t\t\t\t\t\t\t\t\t\tCompression Side Bolts:")
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t  Bolt Name: \t" + "\(  bolt_name )" +  "\t\t  in")
        
        var d_hole_standar: Double = 0.0
        
        // Hole diameter taken for a standar hole from Table J3.3 AISC Specification
        if let value = standar_nominal_hole[ bolt_name] {
            d_hole_standar = value
        }
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t Size Standard hole:\t\t" + "\(  d_hole_standar )" +  "   in")
        
        // Minimum Edge Distance taken for a standar hole from Table J3.4 AISC Specification
        var min_edge_distance: Double = 0.0
        if let value = minimum_edge_distance[bolt_name]{
            min_edge_distance = Double(value)
        }
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t  Minimum edge distance: \t" + "\( min_edge_distance )" +  "    in")
        
        
        // Nominal tearout of the two inner bolts at the compresion side
        
        var ni: Double = 0.0
        var no: Double = 0.0
        
        if connection_type == "8ES" {
            ni = 4
            no = 4
        } else {
            ni = 2
            no = 2
        }
        
        let rn_bearing = round(2.4 * bolt_diameter_selected * tp_selected * Fu_p * 100) / 100
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t   Nominal bearing strength of a sigle bolt:\t\t" + "\(  rn_bearing  )" +    " kips/bolt")
        
        //temp.append("bolt_diameter_selected", bolt_diameter_selected, "tp_selected", tp_selected, "Fu_p", Fu_p )
        
        
        // Nominal tearout of the two inner bolts at the compresion side
        var lc_1: Double = 0.0
        if connection_type == "8ES" {
            lc_1 = pb - d_hole_standar
        } else {
            lc_1 = round((h[0] - h[1] - d_hole_standar) * 100 ) / 100
        }
        
        temp.append("\n\t\t\t\t\t\t  Inner two bolts clear distance in the direction of the force Lc_1:\t\t" + "\(  lc_1  )" +  "     in")
        
        let rn_tearout_inner_bolts = round(1.2 * lc_1 * tp_selected * Fu_p * 10) / 10
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\tNominal tearout for the two inner bolts:\t" + "\(  rn_tearout_inner_bolts  )" +    "  kips/bolt")
        
        // Nominal tearout of the two outside bolts at the compresion side, plate edge
        // Edge distance taken fron table J3.4 AISC espedcification
        
        //let edge_distance = round(1 + 1/4)
        
        if de < min_edge_distance {
            temp.append( "\n\tNOTE:\n\t\t\t\tEdge distance will be updated from " + "\(  de )" +  " in to minimum edge distance" + "\(  min_edge_distance )" +  "  in")
            de = min_edge_distance
        }
        
        let lc_2 = round((de - d_hole_standar/2) * 1000) / 1000
        temp.append("\n\t\t\t\t\tOuter two bolts clear edge distance in the direction of the force Lc_2: \t" + "\(  lc_2  )" +  "  in")
        
        let rn_tearout_edge_bolts = round(1.2 * lc_2 * tp_selected * Fu_p * 10) / 10
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\tNominal tearout for the two edge bolts:\t\t" + "\(  rn_tearout_edge_bolts  )" +    "   kips/bolt")
        
        let rn_tearout = min(rn_tearout_inner_bolts, rn_tearout_edge_bolts)
        
        // Resulting Bearing and tearout design strength for the compresion side bolts in the connection
        // is limited by tear out of the edge bolts and and bearing for the inner bolts
        
        var phi_Rn: Double = 0.0
        phi_Rn = round(0.75 * (no * rn_bearing + ni * rn_tearout))
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t Resulting bearing and tearout design strength:\t\t" + "\( phi_Rn )" +  "  kips")
        
        if phi_Rn >= Vu {
            temp.append("\n\n\t\t\t\t\t\t\t\t\t\t\t\t\tOK. Bearing and Tearout design strength.")
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tBearing and Tearout\t\t phi_Vn:\t" + "\(  phi_Rn )" + " kips \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tis larger then \t\t\t\t Vu:\t" + "\(  Vu )" + " kips\n")
        } else {
            temp.append("\n\t\tPlease, Adjust the configuration")
            temp.append("\nProgram now will crash for you to restart process \nand select a new configuration: \n")
            
            //1/0   # to crash the prorgam      // OJO
            
        }
        
        
        
        temp.append("\n\nDesign of Beam Flange to End-Plate weld")
        
        let Mp_sixty_percent = round(0.6 * Fyb * Zxb)
        temp.append("\n\t\t\t\t\t60% of the beam plastic flexural strength\t\t\t\t\t\t(60%)Mp:\t" + "\(  Mp_sixty_percent )" + " kips")
        temp.append("\t\t\t\t\tRequired flexural strength \t\t\t\t\t\t\t\t\t\t\tMub:\t" + "\(  Mub )" +  " kips")
        
        var Ffu: Double = 0.0
        
        if Mp_sixty_percent < Mub {
            Ffu = round(Mub / (db - tbf))
            temp.append("\n\t\t\t\t\tDesign beam flange to end plate weld for the required strength \t\tFfu:\t" + "\(  Ffu )" +  "  kips/n/n")
        } else {
            Ffu = round(Mp_sixty_percent / (db - tbf))
            
            temp.append("\n\t\t\t\tDesign beam flange to end plate weld for 60% of the beam plastic flexural strength, Ffu :\t" + "\(Ffu )" +  "  kips")
        }
        // Efective lenght of weld available, le, on both sides of the of flanges
        let le = round((bbf + (bbf - tbw)) * 10) / 10
        
        temp.append("\t\t\t\t\tEfective lenght of weld available, on both sides of flanges\t\t\tle:\t\t" + "\(  le )" +  "   in\n")
        
        
        // Weld size
        
        
        temp.append("\n\nDesign of Beam Flange to End-Plate weld\n\n")
        
        var D_selected_beam_flange_end_plate_numerator: Int = 0
        var D_selected_beam_flange_end_platede_nominator: Int = 0
        var D_selected_beam_flange_end_plate: Double = 0.0
        
        temp.append("\t\t\t\t\t\tRequired strength for the beam flange-to-end-plate welds,\t  Ffu:\t\t" + "\(  Ffu )" +  " kips")
        
        // for weld Fexx = 70 ksi, Weld size in sixteenths of an inch
        let D_req_beam_flange_end_plate_sixteenths = round(Ffu / (1.392 * 1.5 * le) * 100) / 100
        temp.append("\t\t\t\t\t\tRequired weld size in sixteenths of an inch, \t\t\t\tDreq'd:\t\t" + "\( D_req_beam_flange_end_plate_sixteenths )" +  "  sixteenths")
        
        
        let D_selected_beam_flange_end_plate_sixteenths = ceil(D_req_beam_flange_end_plate_sixteenths)
        temp.append("\t\t\t\t\t\tRounded required weld size in sixteenths of an inch, \t\tDreq'd:\t\t" + "\( D_selected_beam_flange_end_plate_sixteenths )" +  "   sixteenths")
        
        //var D_selected_beam_flange_end_plate_numerator : Int = 0
        //var D_selected_beam_flange_end_platede_nominator : Int = 0
        //var D_selected_beam_flange_end_plate : Double = 0.0
        
        (D_selected_beam_flange_end_plate_numerator, D_selected_beam_flange_end_platede_nominator, D_selected_beam_flange_end_plate) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: D_selected_beam_flange_end_plate_sixteenths)
        
        temp.append("\n\tUse two fillet welds (Two-sided) to weld the continuity plates to column flage :   \(String(describing: D_selected_beam_flange_end_plate_numerator))/\(String(describing: D_selected_beam_flange_end_platede_nominator))  in,  equal to \(D_selected_beam_flange_end_plate)  in  ")
        
        D_selected_beam_flange_end_plate = minimumWeldSizeVerification(tbw: tbf, tpSelected: tp_selected, dWShearSelected: D_selected_beam_flange_end_plate)
        maximumWeldSizeVerification(tbw: tbf, tpSelected: tp_selected, dWShearSelected: D_selected_beam_flange_end_plate)
        
        temp.append("\n\n")
        
        
        
        temp.append("\n\nDesign of Beam Web to End-Plate weld\n\n")
        
        var D_selected_beam_web_end_plate_numerator: Int = 0
        var D_selected_beam_web_end_plate_denominator : Int = 0
        var D_selected_beam_web_end_plate: Double = 0.0
        
        // Beam web plastic capacity
        let phi_Rn_beam_web = round(phi_b * Fyb * tbw * 10) / 10
        temp.append("\t\t\tBeam web plastic capacity \t\t\t\t\t\t\t\t\t\t\t\tɸ Rn_w:\t\t"  + "\(  phi_Rn_beam_web )" +  "  kip/in")
        
        
        // Weld size
        // for weld Fexx = 70 ksi, Weld size in sixteenths of an inch
        let D_req_beam_web_end_plate_sixteenths = round(phi_Rn_beam_web/2/1.392/1.5 * 10) / 10
        temp.append("\t\t\tRequired weld size in sixteenths of an inch, \t\t\t\t\t\t\tDreq'd:\t\t" + "\( D_req_beam_web_end_plate_sixteenths )" +  "   sixteenths")
        
        
        let D_selected_beam_web_end_plate_sixteenths = ceil(D_req_beam_web_end_plate_sixteenths)
        temp.append("\t\t\tRounded required weld size in sixteenths of an inch, \t\t\t\t\tDreq'd:\t\t" + "\( D_selected_beam_web_end_plate_sixteenths )" +  "   sixteenths")
        
        (D_selected_beam_web_end_plate_numerator, D_selected_beam_web_end_plate_denominator, D_selected_beam_web_end_plate) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: D_selected_beam_web_end_plate_sixteenths)
        temp.append("\n\tUse two fillet welds (Two-sided) to weld the continuity plates to column flage :   \(D_selected_beam_web_end_plate_numerator)/\(D_selected_beam_web_end_plate_denominator)  in,  equal to  \(D_selected_beam_web_end_plate)  in  ")
        
        D_selected_beam_web_end_plate = minimumWeldSizeVerification(tbw: tbw, tpSelected: tp_selected, dWShearSelected: D_selected_beam_web_end_plate)
        maximumWeldSizeVerification(tbw: tbw, tpSelected: tp_selected, dWShearSelected: D_selected_beam_web_end_plate)
        
        temp.append("\n\n")
        
        
        
        
        // Required shear be resisted by welds
        temp.append("\n\nRequired shear be resisted by welds\n\n")
        
        temp.append("\t\t\tMaximum Shear force of design\t\t\t\t\t\t\t\t\t\t\t\tVu:\t\t"  + "\(  Vu )" +  "  kips")
        
        // The lenght of weld available for shear is
        let lw_shear_1 = db / 2 - tbf
        var lw_shear_2: Double = 0.0
        
        // Asuming simetrical distrution of bolts
        if connection_type == "8ES" {
            lw_shear_2 = h[4] + 2 * bolt_diameter_selected - tbf / 2
        } else {
            lw_shear_2 = h[1] + 2 * bolt_diameter_selected - tbf / 2
        }
        
        // lesser distance
        let lw_shear = min(lw_shear_1, lw_shear_2)
        
        let D_req_web_shear_sixteenths = round(Vu / 2 / 1.392 / lw_shear * 100) / 100
        temp.append("\t\t\tRequired weld size in sixteenths of an inch,\t\t\t\t\t\t\tDreq'd:\t\t" + "\(  D_req_web_shear_sixteenths )" +  "  sixteenths")
        
        let D_selected_web_shear_sixteenths = ceil(D_req_web_shear_sixteenths)
        temp.append("\t\t\tRounded required weld size in sixteenths of an inch,\t\t\t\t\tDreq'd:\t\t" + "\( D_selected_web_shear_sixteenths )" +  "   sixteenths")
        
        var (D_selected_web_shear_numerator, D_selected_web_shear_denominator, D_selected_web_shear) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: D_selected_web_shear_sixteenths)
        temp.append("\n\tUse two fillet welds (Two-sided) for the beam web-to-end-plate weld:  \(D_selected_web_shear_numerator)/\(D_selected_web_shear_denominator)  in,  equal to  \(D_selected_web_shear)  in  ")
       
        D_selected_web_shear = minimumWeldSizeVerification(tbw: tbw, tpSelected: tp_selected, dWShearSelected: D_selected_web_shear)
        maximumWeldSizeVerification(tbw: tbw, tpSelected: tp_selected, dWShearSelected: D_selected_web_shear)
        
        temp.append("\n\n")
        
        
        // Final web weld detail   # CORREGIR Denominar y Numerador
        
        let D_w_selected = max(D_selected_web_shear_sixteenths, D_selected_beam_web_end_plate_sixteenths)
        var D_selected_web_shearnumerator: Int = 0
        var D_selected_web_sheardenominator : Int = 0
        
        (D_selected_web_shearnumerator, D_selected_web_sheardenominator, D_selected_web_shear) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: D_w_selected)
        temp.append("\n\tFinal Web Weld Detail:")
        temp.append("\n\t\t\tUse two fillet welds (Two-sided) for the beam Web-to-end-plate weld :  \t \(D_selected_web_shearnumerator)/\(D_selected_web_sheardenominator)  in, equal to \(D_selected_web_shear) in ")
        temp.append("\n\n")
        
        
        
        temp.append("\nUnstiffened Column Flange Flexural Strength will be evaluated\n")
        
        temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tReference values")
        
        // From Table 3.4 AISC Design Guide 4
        let S_c = round(0.5 * sqrt(bcf * g) * 100) / 100
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tS value:\t" + "\( S_c )" +  "  in")
        
        let c = round((pfo + tbf + pfi) * 100 ) / 100
        
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tc value:\t" + "\( c )" +  "  in")
        
        // temp.append(is_column_flange_unstiffened)
        
        var Yc = switchColumnFlangeStiffeningForYc(
            isColumnFlangeUnstiffened: is_column_flange_unstiffened,
            connectionType: connection_type,
            c: c,
            bcf: bcf,
            S_c: S_c,
            g: g,
            pfo: pfo,
            pfi: pfi,
            pb: pb,
            h0: h[0],
            h1: h[1],
            h2: h[2],
            h3: h[3],
            S_p: S_p,
            ycColumnUnstiffened4Eor4ES: ycColumnUnstiffened4Eor4ES,
            ycColumnStiffened4Eor4ES: ycColumnStiffened4Eor4ES,
            ycColumnUnstiffened8ES: ycColumnUnstiffened8ES,
            ycColumnStiffened8ES: ycColumnStiffened8ES
        )
        
        Yc = round(Yc)
        
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t   Yp value:\t" + "\(  Yc )" +  "\t in")
        
        // From AISC Design Guide 4, Table 3.4, the available strength of the unstiffened column flange is
        let phi_Mcf_u = round(phi_b * Fyc * Yc * pow(tcf,2))
        temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tɸ Mcf value:\t\t" + "\(  phi_Mcf_u  )" +  "  kip-in")
        
        var t_cp: Double = 0.0
        
        if phi_Mcf_u < Mub {
            temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tWARNING:  \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t  ɸ Mcf:\t\t" + "\(  phi_Mcf_u )" +  " kips-in \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tis less than \tMub:\t" + "\(  Mub )" +  " kips-in")
            temp.append("\n\n\t\t\t\t\t\t\t\t\t\t\t   NOTE:")
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t   The column will Require Continuity Plates\n")
            
            continuity_plates = true
            is_column_flange_unstiffened = false
            
            // Initial try will be using continuity plates thickness close to the thickness of the beam flanges
            
            // list of plate thickness values
            let list_of_plate_thickness = Array(plates_thickness_in.values)
            
            // Initial try equal to beam flange thickness
            let target_value = tbf
            
            // Search for the nearest value
            t_cp = nearestValueInAList(list: list_of_plate_thickness, targetValue: target_value)
            temp.append("\t\t\t\t\t\t\t\t\t\t\t Nearest value of the continuity plate thickness \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tto the beam flange thickness is:\t" + "\(  t_cp )" +  "  in")
            
            var t_cp_numerator: Int = 0
            var t_cp_denominator: Int = 0
            (t_cp_numerator, t_cp_denominator, t_cp) = plateSize(DSelected: t_cp)
            
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\tAs the Column will require coninuity plates:")
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tTRY:\t\(t_cp_numerator)/\(t_cp_denominator) in = \(t_cp) in, " )
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tthick coninuity plates ")
            
        } else {
            temp.append("\n\nNOTE:")
            temp.append("\n\tThe column will NOT Require Continuity Plates\n\n")
        }
        
        
        
        var Yc_s: Double = 0.0
        var phi_Mcf_s: Double = 0.0
        
        // continuity_plates = True
        
        
        
        if continuity_plates == false {
            temp.append("\nIn this case: \n\n\t\"No\" Coninuity plates are requiered:")
            temp.append("\n\t\tɸ Mcf =" + "\(  phi_Mcf_u )" +  " kips-in is larger than MUb =" + "\(  Mub )" +  " kips-in")
            temp.append("\n\tIf the connection is at the top of the column, extend the column at least a distance, \"s\",")
            temp.append("\t\"s\" = " + "\(  S_c )" + " in, above the top bolt, and include a cap plate.\n")
            
        } else {
            
            temp.append("\nStiffened Column Flange Flexural Strength will be evaluated")
            
            pfo = round((c - t_cp) / 2 * 100) / 100
            
            
            temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tReference values")
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tpfo and pfi:\t" + "\(  pfo )" +  "  in")
            
            Yc_s = switchColumnFlangeStiffeningForYc(
                isColumnFlangeUnstiffened: is_column_flange_unstiffened,
                connectionType: connection_type,
                c : c,
                bcf : bcf,
                S_c : S_c,
                g : g,
                pfo : pfo,
                pfi : pfi,
                pb : pb,
                h0 : h[0],
                h1 : h[1],
                h2 : h[2],
                h3 : h[3],
                S_p : S_p,
                ycColumnUnstiffened4Eor4ES : ycColumnUnstiffened4Eor4ES,
                ycColumnStiffened4Eor4ES : ycColumnStiffened4Eor4ES,
                ycColumnUnstiffened8ES : ycColumnUnstiffened8ES,
                ycColumnStiffened8ES : ycColumnStiffened8ES
                
            )
            //temp.append("\tYc value: \t\t\t\t\t", Yc, "  in")
            
            Yc_s = round(Yc_s)
            
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t   Yp value:\t" + "\(  Yc_s )" +  "\t in")
            
            phi_Mcf_s = round(phi_b * Fyc * Yc_s * pow(tcf,2))
            
            temp.append("\n\tFrom AISC Design Guide 4, Equation 3.21:")
            temp.append("\t\t\t\t\t\t\t\tAvailable strength of the siffened column\t\t\tɸ Mcf_s:\t\t" + "\(   phi_Mcf_s )" +  "  kips-in")
        }
        
        if phi_Mcf_s < Mub {
            temp.append("\n\nWARNING:  \n\t\tɸMcf =" + "\(  phi_Mcf_s )" +  " kips-in is less than MUb =" + "\(  Mub )" +  " kips-in")
            temp.append("\n\tSelect another column with a larger flange strength")
            temp.append("\tChange the column and re-start the process all over again from the beginning.")
            is_column_strong_enough = false
            
            temp.append("Program will crash")
            //      1/0
            
        } else {
            temp.append("\n\n\tNOTE:")
            temp.append("\t\tThe connection will be adecquate if continuity plates are added and they are designed as follows.")
            temp.append("\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tBecause:")
            temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tStiffened \t\t\tɸ Mcf:\t\t" + "\(  phi_Mcf_s )" +  " kips-in \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tis larger than\t\tMub:\t\t" + "\(  Mub )" +  " kips-in\n\n")
        }
        
        
        
        temp.append("Column Continuity Plates and Welds")
        
        // temp.append("Maximum Available Beam Flange Force that can be delivered to the Column")
        
        var phi_Rn_bff: Double = 0.0
        if (is_column_strong_enough  && continuity_plates == false) {
            temp.append("\n\t\tThis section will be skipped")
        } else {
            phi_Rn_bff = round(phi_Mcf_u / (db - tbf))
            temp.append("\n\tMaximum available beam flange force that can be delivered to the column\t\t\tɸ Rn_bf:\t\t" + "\(phi_Rn_bff)" + "  kips")
            //temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tɸ Rn_bf:\t\t", phi_Rn_bff, "  kips")
        }
        
        
        
        //temp.append("\n\tNominal Column Web Local Yielding Strength")

        var Ct: Double = 0.0
        var N: Double = 0.0
        var phi_cwy: Double = 0.0
        var Rn_cwy: Double = 0.0
        var phi_Rn_cwy: Double = 0.0
        
        if (is_column_strong_enough  && (continuity_plates == false)) {
            temp.append("\n\t\tThis section will be skipped")
        } else {
            
            if (top_column_connection == true) {
                
                if (top_column_distance < (dc / 2)) {
                    Ct = 0.5
                } else {
                    Ct = 1.0
                }
                
            } else {
                Ct = 1.0
            }
            
            
            phi_cwy = 1.0
            
/*
    NOTE:
        
        N : Fillet Welds: beam flange thikness plus the filet weld size of the flange
        times 0.707.
                                    
        N : Groove Welds: beam flange thikness plus two times the weld reinforcement if USED.
        leg size = 5/16 maximum.
*/
            
            N = tbf + 0.707 * D_selected_beam_flange_end_plate
            
            Rn_cwy = (Ct * (6 * kdes_c + 2 * tp_selected) + N) * Fyc * tcw
            
            phi_Rn_cwy = round(phi_cwy * Rn_cwy)
            temp.append("\tAvailable Column Web Local Yielding\t\t\t\t\t\t\t\t\t\t\t\tɸ Rn_cwy:\t" + "\(phi_Rn_cwy)" + "  kips")
            //temp.append("\n\t\tɸRn_cwy = \t\t\t", phi_Rn_cwy, "  kips\n")
            
        }
        
        
        
        
        //temp.append("\tNominal Column Web Local Crippling Strength")
        
        var phi_wcr: Double = 0.0
        var Rn_cwcr: Double = 0.0
        var phi_Rn_cwcr: Double = 0.0
        var Qf: Double = 0.0
        
        if (is_column_strong_enough  && continuity_plates == false) {
            
            temp.append("\n\t\tThis section will be skipped")
            
        } else {
            
            phi_wcr = 0.75
            
            Qf = 1.0     // for wide flange sections and HSS (conecting section) in tension.
            // see Table K3.2 for all other HSS conditions
            
            Rn_cwcr = 0.80 * pow(tcw,2)*(1 + 3 * ( N / dc ) * pow((tcw/tcf), 1.5)) * sqrt((Es * Fyc * tcf) / tcw) * Qf
            
            //    temp.append(tcw, N, dc, tcf, Es, Fyc, Qf)
            
            //    phi_Rn_cwcr = phi_wcr * round(Rn_cwcr, 0)
            
            phi_Rn_cwcr = round(phi_wcr * Rn_cwcr)
            temp.append("\tAvailable Column Web Local Crippling strength\t\t\t\t\t\t\t\t\tɸ Rn_cwy:\t" + "\(phi_Rn_cwcr)" +  "  kips\n")
            //temp.append("\n\t\tɸRn_cwy = \t\t", phi_Rn_cwcr, "  kips\n")
        }
        
        
        
        
        //temp.append("\tContinuity Plate Required Strength")
        
        var Fcu: Double = 0.0
        if (is_column_strong_enough  && continuity_plates == false) {
            
            temp.append("\n\t\tThis section will be skipped")
            
        } else {
            Fcu = Ffu - min(phi_Rn_bff, phi_Rn_cwy, phi_Rn_cwcr )
            
            temp.append("\tContinuity Plate Required Strength\t\t\t\t\t\t\t\t\t\t\t\tFcu:\t\t" + "\(Fcu)" +  "  kips\n")
            //temp.append("\n\t\tFcu = \t\t\t", Fcu, "  kips\n")
        }
        
        
        
        
        //temp.append("Clip Dimension")
        
        var Sweb_imperial: String = ""
        var Sweb: Double = 0.0
        var lp: Double = 0.0
        var Sflange_base: Double = 0.0
        var Sflange_imperial: String = ""
        var Sflange: Double = 0.0
        var  bp_uncut_imperial: String = ""
        var bp_uncut: Double = 0.0
        var bp: Double = 0.0
        
        if (is_column_strong_enough  && continuity_plates == false) {
            
            temp.append("\n\t\tThis section will be skipped")
            
        } else {
            
            temp.append("\n\nCONTUNUITY PLATES CLIP SIZES")
            
            
            temp.append("\n\n\t1. WEB side:")
            // Clip size along the web, measured relative to the uncutcontinuity plate
            
            let Sweb_base = kdet_c + 1.5 - tcf
            (Sweb_imperial, Sweb) = roundUpToEighths(Sweb_base)
            
            temp.append("\n\t\tClip size along the web shall be equal or larger than\t\t\t\tSweb:\t" + "\(Sweb_imperial)" +  " in equal to " + "\(Sweb)" +  " in")
            //temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tSweb:\t", Sweb_imperial, " in equat to ", Sweb, " in")
            
            // Contact length between the continuity plate and the column web, lp
            
            lp = dc - 2*tcf - 2*Sweb
            
            temp.append("\t\tContact length between the continuity plate and the column web\t\tlp:\t\t" + "\(lp)" +  "  in")
            //temp.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tlp:\t\t", lp, "  in")
            
            temp.append("\n\n\t2. FLANGE side:")
            // Clip size along the flange, measured relative to the uncutcontinuity plate
            
            Sflange_base = k1_c + (1 / 2) - (tcw / 2)
            Sflange_base = Sflange_base - (1 / 4)     // to make it less than and not equal to
            
            (Sflange_imperial, Sflange) = roundDownToEighths(Sflange_base)
            
            
            temp.append("\n\t\tClip size along the flange shall be equal or less than\t\t\t\tSweb:\t" + "\(Sflange_imperial)" +  "  in equal to " + "\(Sflange)" +  " in")
            //temp.append("\t\tSweb = \t\t", Sflange_imperial, "  in = ", Sflange, "  in")
            
            // uncuted continuity plate width trial
            let bp_uncut_base = (bcf - tcw) / 2
            (bp_uncut_imperial, bp_uncut) = roundDownToQuarters(bp_uncut_base)
            
            temp.append("\t\tUncut width trial of the continuity plate\t\t\t\t\t\t\tSweb:\t" + "\(bp_uncut_imperial)" +  "\t in equal to " + "\(bp_uncut)" +  " in")
            //temp.append("\t\tSweb = \t\t", bp_uncut_imperial, "\t  in equal to ", bp_uncut, "  in")
            
            // Contact length between the continuity plate and the column web, bp
            bp = bp_uncut - Sflange
            // bp= 2.75 as in the example
            
            temp.append("\t\tContact length between the continuity plate and the column flange\tbp = \t" + "\(bp)" +  "  in\n\n")
            //temp.append("\t\tbp = \t\t", bp, "  in\n\n")
        }
        
        
        
        
        //temp.append("Axial and Shear Strength per continuity plate")
        
        var Pu_cp: Double = 0.0
        var Pn_cp: Double = 0.0
        var phi_Pn_cp: Double = 0.0
        var Vn_cp: Double = 0.0
        var phi_s_cp: Double = 0.0
        var phi_Vn_cp: Double = 0.0
        
        if (is_column_strong_enough  && continuity_plates == false) {
            
            temp.append("\n\t\tThis section will be skipped")
            
        } else {
            temp.append("\n\nAVAILABLE AXIAL AND SHEAR STRENGTH PER CONTINUITY PLATE ")
            
            
            // Required Axial strength per continuity plate
            
            
            
            Pu_cp = Fcu / 2
            temp.append("\n\n\t\tRequired Axial Strength per Continuity Plate\t\t\t\t\t\t\t\tPu_cp:\t\t" + "\(Pu_cp)" +  " kips")
            //temp.append("Pu_cp: ",Pu_cp, " kips")
            
            //temp.append("\n\n\t\tRequired Axial strength per continuity plate:")
            
            
            // From AISC Specification Equation J4-6, the available axial strength per continuity plate
            
            Pn_cp = Fycp * t_cp * bp
            //temp.append("Pn_cp: " + "\(Pn_cp)
            
            let phi_as_cp = 0.90
            
            phi_Pn_cp = round(phi_as_cp * Pn_cp * 10 ) / 10
            temp.append("\t\tAvailable Axial strength per continuity plate\t\t\t\t\t\t\t\tphi_Pn_cp:\t" + "\(phi_Pn_cp)" +  " kips")
            
            //    if phi_Pn_cp >= Pu_cp {
            //
            //        temp.append("\n\t\t\t\tOK : \n\t\t\t\t\t\tAvailable AXIAL strength per continuity plate: \t\tphi_Pn_cp:\t",
            //              phi_Pn_cp, " kips, \n\t\t\t\t\t\tis larger than Required Axial strength:\t\t\t\tPu_cp:\t\t", Pu_cp, " kips\n")
            //
            //    } else {
            //        temp.append("\n\t\tWARING : \n\t\tAvailable axial strength per continuity plate: \t",
            //              phi_Pn_cp, " kips, \n\t\tis LESS than Required Axial strength: \t\t", Pu_cp, " kips\n")
            //        //    1/0   # to crash the program
            //    }
            
            
            
            
            // From AISC Specification Equation J4-3,
            // Available shear yield strength of the continuity plate along the column web
            
            Vn_cp = 0.60 * Fycp * t_cp * lp
            //temp.append("Vn_cp: " + "\(Vn_cp)
            
            phi_s_cp = 1.00
            
            phi_Vn_cp = round(phi_s_cp * Vn_cp * 10 ) / 10
            //temp.append("phi_Vn_cp: " + "\(phi_Vn_cp)
            
            
            if phi_Vn_cp >= Pu_cp {
                temp.append("\n\t\t\t\tOK : \n\t\t\t\t\t\tAvailable SHEAR strength per continuity plate\t\t\t\tphi_Vn_cp:\t" + "\(phi_Vn_cp)" +  " kips, \n\t\t\t\t\t\tis larger than Required Axial strength\t\t\t\t\t\tPu_cp:\t\t" + "\(Pu_cp)" +  " kips\n")
            } else {
                temp.append("\n\t\t\tWARING : \n\t\tAvailable axial strength per continuity plate phi_Vn_cp: \t" + "\(phi_Vn_cp)" +  " kips, \n\t\tis LESS than Required Axial strength Pu_cp: \t\t\t" + "\(Pu_cp)" +  " kips\n")
                temp.append( "\(phi_s_cp)" +  "\( Vn_cp)")
                
                //   1/0   # to crash the program
            }
            
        }
        
        
        
        
        //temp.append("Weld of Continuity Plate to Column Flange")
        
        var D_cp_flange_numerator: Int = 0
        var D_cp_flange_denominator: Int = 0
        var D_cp_flange_selected: Double = 0.0
        
        if (is_column_strong_enough  && continuity_plates == false) {
            temp.append("\n\t\tThis section will be skipped")
        } else {
            
            temp.append("\n\nWeld of Continuity Plate to Column Flange\n\n")
            
            temp.append("\t\tRequired Axial strength per continuity plate\t\t\t\t\t\t\t\tPu_cp:\t\t" + "\(Pu_cp)" + "\t   kips" )
            
            let D_req_cp_flange_sixteenths = round(Pu_cp / (2 * 1.392 * 1.5 * bp) * 100) / 100
            
            temp.append("\t\tRequired weld size in sixteenths of an inch,\t\t\t\t\t\t\t\tDreq'd:\t\t" + "\(D_req_cp_flange_sixteenths)" +  "   sixteenths")
            
            
            let D_selected_cp_flange_sixteenths = ceil(D_req_cp_flange_sixteenths)
            temp.append("\t\tRounded required weld size in sixteenths of an inch,\t\t\t\t\t\tDreq'd:\t\t" + "\(D_selected_cp_flange_sixteenths)" +  "    sixteenths")
            
            (D_cp_flange_numerator, D_cp_flange_denominator, D_cp_flange_selected) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: D_selected_cp_flange_sixteenths)
            
            temp.append("\n\tUse two fillet welds (Two-sided) to weld the continuity plates to column flage:   \(D_cp_flange_numerator)/\(D_cp_flange_denominator)  in equal to  \(D_cp_flange_selected)  in  ")
            
            D_cp_flange_selected = minimumWeldSizeVerification(tbw: tcf, tpSelected: t_cp, dWShearSelected: D_cp_flange_selected)
            maximumWeldSizeVerification(tbw: tcf, tpSelected: t_cp, dWShearSelected: D_cp_flange_selected)
            
            temp.append("\n\n")
        }
        
        
        
        //temp.append("Weld of Continuity Plate to Column Web")
        
        var D_cp_web_numerator: Int = 0
        var D_cp_web_denominator: Int = 0
        var D_cp_web_selected: Double = 0.0
        
        if (is_column_strong_enough  && continuity_plates == false) {
            
            temp.append("\n\t\tThis section will be skipped")
            
        } else {
            
            temp.append("\n\nWeld of Continuity Plate to Column Web\n\n")
            
            temp.append("\t\tRequired Shear strength per continuity plate\t\t\t\t\t\t\t\tPu_cp:\t\t" + "\( Pu_cp)" + "   kips" )
            
            let D_req_cp_web_sixteenths = round(Pu_cp / (2 * 1.392 * lp) * 100) / 100
            
            temp.append("\t\tRequired weld size in sixteenths of an inch,\t\t\t\t\t\t\t\tDreq'd:\t\t" + "\(D_req_cp_web_sixteenths)" +  "   sixteenths")
            
            
            let D_selected_cp_web_sixteenths = ceil(D_req_cp_web_sixteenths)
            temp.append("\t\tRounded required weld size in sixteenths of an inch,\t\t\t\t\t\tDreq'd:\t\t" + "\(D_selected_cp_web_sixteenths)" +  "    sixteenths")
            
            (D_cp_web_numerator, D_cp_web_denominator, D_cp_web_selected) = weldSizeFromSixteenthsToFraction(DSelectedSixteenths: D_selected_cp_web_sixteenths)
            
            temp.append("\n\tUse two fillet welds (Two-sided) to weld the continuity plates to column flage :   \(D_cp_web_numerator)/\(D_cp_web_denominator)    in equat to \(D_cp_web_selected)  in  ")
            
            
            D_cp_web_selected = minimumWeldSizeVerification(tbw: tcw, tpSelected: t_cp, dWShearSelected: D_cp_web_selected)
            maximumWeldSizeVerification(tbw: tcw, tpSelected: t_cp, dWShearSelected: D_cp_web_selected)
            
            if D_cp_flange_selected > D_cp_web_selected {
                
                temp.append("\n\n\tNOTE 2:")
                temp.append("\n\t\t\tIt's recommended the next: ")
                temp.append("\n\t\t\tUse two fillet welds (Two-sided) to weld the continuity plates to column flage :   \(D_cp_flange_numerator)/\(D_cp_flange_denominator)   in equal to  \(D_cp_flange_selected)  in  ")
                temp.append("\t\t\tto use the same weld size as used on the column flange")
                temp.append("\n\n\tEnd.\n\n")
            }
        }
        
        print("SUCCESS !!")
        
        for item in temp {
            print(item)
        }

    }
}


