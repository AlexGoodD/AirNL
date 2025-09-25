//
//  AirNLApp.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import SwiftData

@main
struct AirNLApp: App {
    @StateObject private var locationRepo = LocationRepository()
    
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            //            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationRepo)
        }
        .modelContainer(sharedModelContainer)
    }
}
