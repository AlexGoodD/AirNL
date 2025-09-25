//
//  ContentView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var locationRepo: LocationRepository
    
    var body: some View {
#if os(iOS)
        iOSRootView()
#elseif os(macOS)
        macOSRootView()
#endif
    }
    
}

#Preview {
    ContentView()
        .environmentObject(LocationRepository())
//        .modelContainer(for: Item.self, inMemory: true)
}
