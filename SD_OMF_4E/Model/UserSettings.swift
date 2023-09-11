//
//  UserSettings.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var selectedSpecification: ASTM.Specification = .a572 {
        didSet {
            UserDefaults.standard.set(selectedSpecification.rawValue, forKey: "selectedEndPlateSpecification")
        }
    }
    
    init() {
        if let storedSpecificationValue = UserDefaults.standard.string(forKey: "selectedEndPlateSpecification"),
           let storedSpecification = ASTM.Specification(rawValue: storedSpecificationValue) {
            selectedSpecification = storedSpecification
        }
    }
}
