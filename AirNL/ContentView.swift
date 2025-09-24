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
    @Query private var items: [Item]
    
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
        .modelContainer(for: Item.self, inMemory: true)
}
