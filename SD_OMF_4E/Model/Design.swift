//
//  Design.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import Foundation

struct Design: Identifiable, Codable {
    let id: Int
    let creationDate: Date
    let connectionType: String
    var project: String
    var designers: [Designer]
    var beam : BeamProperties
//    var beamViewModel: BeamViewModel
    var column: ColumnProperties
//    var columnViewModel: ColumnViewModel
    var theme: Theme
    var history: [History] = []
    
    init(id: Int = Design.getNextId(), connectionType: String = Design.getConnectionType(), project: String,
         designers: [String], beam: BeamProperties,  column: ColumnProperties,  theme: Theme){
        
//    init(id: Int = Design.getNextId(), connectionType: String = Design.getConnectionType(), project: String,
//         designers: [String], beam: BeamProperties, beamViewModel: BeamViewModel, column: ColumnProperties, columnViewModel: ColumnViewModel, theme: Theme){
        self.id = id
        self.creationDate = Date() // Storing the current date
        self.connectionType = connectionType
        self.project = project
        self.designers = designers.map { Designer(name: $0) }
        self.beam = beam
//        self.beamViewModel = beamViewModel
        self.column = column
//        self.columnViewModel = columnViewModel
        self.theme = theme
    }
    
    static func getNextId() -> Int {
        // Check if the app has been launched before
        if UserDefaults.standard.value(forKey: "isFirstLaunch") == nil {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            UserDefaults.standard.set(0, forKey: "DesignCurrentId")
        }
        
        let currentId = UserDefaults.standard.integer(forKey: "DesignCurrentId")
        let nextId = currentId + 1
        UserDefaults.standard.set(nextId, forKey: "DesignCurrentId")
        return nextId
    }
    
    static func getConnectionType() -> String {
        let connectionType = "8ES"
        return connectionType
    }
}

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

extension Design {
    struct Designer: Identifiable, Codable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
    
    
    static var emptyDesign: Design {
        Design(connectionType: "", project: "", designers: [],
               beam:  BeamProperties(
                id: "",
                AISC_Manual_Label: "",
                d: "",
                tw: "",
                bf: "",
                tf: "",
                Zx: "",
                WGi: ""),
               column:ColumnProperties(
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
                theme: .sky)
    }
}



extension Design {
    static let sampleData: [Design] =
    [
        Design(connectionType: "4E", project: "Las Auroras",
               designers: ["Cathy", "Daisy", "Simon", "Jonathan"],
               beam: BeamProperties(
                id: "W18X40",
                AISC_Manual_Label: "W18X40",
                d: "17.9",
                tw: "0.315",
                bf: "6.02",
                tf: "0.525",
                Zx: "78.4",
                WGi: "3.5"),
               column: ColumnProperties(
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
               theme: .yellow),
        Design(connectionType: "4ES", project: "Playa Hermosa",
               designers: ["Katie", "Gray", "Euna", "Luis", "Darla"],
               beam: BeamProperties(
                id: "W18X40",
                AISC_Manual_Label: "W18X40",
                d: "17.9",
                tw: "0.315",
                bf: "6.02",
                tf: "0.525",
                Zx: "78.4",
                WGi: "3.5"),
               column: ColumnProperties(
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
               theme: .orange),
        Design(connectionType: "8ES", project: "New York Best Seller",
               designers: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"],
               beam: BeamProperties(
                id: "W18X40",
                AISC_Manual_Label: "W18X40",
                d: "17.9",
                tw: "0.315",
                bf: "6.02",
                tf: "0.525",
                Zx: "78.4",
                WGi: "3.5"),
               column: ColumnProperties(
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
               theme: .poppy),
    ]
}
