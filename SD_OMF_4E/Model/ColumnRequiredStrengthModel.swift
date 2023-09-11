//
//  ColumnRequiredStrengthModel.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/11/23.
//

import Foundation

class ColumnRequiredStrengthModel: ObservableObject {
    @Published var columnRequiredStrength: ColumnRequiredStrength

    init(columnRequiredStrength: ColumnRequiredStrength) {
        self.columnRequiredStrength = columnRequiredStrength
    }

    func saveData() {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(columnRequiredStrength)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("columnRequiredStrength.json")
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
                .appendingPathComponent("columnRequiredStrength.json")

            if FileManager.default.fileExists(atPath: fileURL.path) {
                let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                let decoder = JSONDecoder()
                let data = try decoder.decode(ColumnRequiredStrength.self, from: jsonString.data(using: .utf8)!)
                columnRequiredStrength = data
                print("Data loaded successfully!")
            } else {
                print("File does not exist")
            }
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }

    func isValid() -> Bool {
        return isDoubleValue(columnRequiredStrength.Puc_1String)
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
