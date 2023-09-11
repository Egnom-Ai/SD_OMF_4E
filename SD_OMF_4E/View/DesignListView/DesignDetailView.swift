//
//  DesignDetailView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/9/23.
//

import SwiftUI

struct DesignDetailView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var designStore = DesignStore()
    @State private var showNewDesignSheet = false
    var design: Design

    var body: some View {
        
        ZStack{
            //            Color.indigo.edgesIgnoringSafeArea(.all)
            //                .opacity(0.50)
            NavigationStack {
                VStack {
                    
                    Text("Connection Details")
                        .font(.title)
                        .padding()
                    
                    Text("Project: \(design.project)")
                    // Display other properties
                    Text("Beam Section: \(design.beam.AISC_Manual_Label)")
                    Text("Column Section: \(design.column.AISC_Manual_Label)")
                    Text("Theme Color: \(design.theme.rawValue)")
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(design.theme.mainColor)
    //        .ignoresSafeArea()
            }
            .navigationTitle("Designs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit Data") {
                        showNewDesignSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showNewDesignSheet) {
                if let designIndex = designStore.designs.firstIndex(where: { $0.id == design.id }) {
                    EditDesignSheet(designStore: designStore, designIndex: designIndex)
                }
            }

        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                Task {
                    do {
                        try await designStore.save(designs: designStore.designs)
                        print("Data saved to storage")
                    } catch {
                        print("Failed to save designs")
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    try await designStore.load()
                    print("Data loaded from storage")
                } catch {
                    print("Failed to load designs")
                }
            }
        }
    }

    // Add this function
    func deleteDesign(at offsets: IndexSet) {
        designStore.designs.remove(atOffsets: offsets)
        
        // Save the updated designs array to storage
        Task {
            do {
                try await designStore.save(designs: designStore.designs)
                print("Data saved to storage after deletion")
            } catch {
                print("Failed to save designs after deletion")
            }
        }
    }
}

struct DesignDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        let sampleDesign = Design.sampleData[0]
        return DesignDetailView(design: sampleDesign)
    }
}
