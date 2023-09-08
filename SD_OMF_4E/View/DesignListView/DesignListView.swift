//
//  DesignListView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct DesignListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var designStore = DesignStore()
    @State private var showNewDesignSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(designStore.designs.indices, id: \.self) { index in
                    NavigationLink(destination: EditDesignSheet(designStore: designStore, designIndex: index)) {
                        CardView(design: designStore.designs[index])
                    }
                    .listRowBackground(designStore.designs[index].theme.mainColor)
                }
                .onDelete(perform: deleteDesign) // Add this line
            }
            .navigationTitle("Steel Connections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Design") {
                        showNewDesignSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showNewDesignSheet) {
                NewDesignSheet(designStore: designStore)
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

struct DesignListView_Previews: PreviewProvider {
    static var previews: some View {
        DesignListView()
    }
}
