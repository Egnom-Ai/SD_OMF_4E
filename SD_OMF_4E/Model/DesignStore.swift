//
//  DesignStore.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

@MainActor
class DesignStore: ObservableObject {
    @Published var designs: [Design] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("designs.data")
    }

    func load() async throws {
        let task = Task<[Design], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyDesigns = try JSONDecoder().decode([Design].self, from: data)
            return dailyDesigns
        }
        let designs = try await task.value
        self.designs = designs
    }

    func save(designs: [Design]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(designs)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
