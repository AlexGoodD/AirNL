//
//  AirNLApp.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import UserNotifications
import SwiftData

@main
struct AirNLApp: App {
    @StateObject private var locationRepo = LocationRepository()
    
    private let airRepository: AirRepositoryProtocol
    private let healthRepository: HealthRepositoryProtocol
    
    init() {
#if DEBUG
#if targetEnvironment(simulator)
        airRepository = MockAirRepository()
        healthRepository = MockHealthRepository()
#else
        airRepository = AirRepository.shared
        healthRepository = HealthRepository()
#endif
#else
        airRepository = AirRepository.shared
        healthRepository = HealthRepository()
#endif
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("❌ Error pidiendo permisos: \(error)")
                } else {
                    print("✅ Permiso notificaciones: \(granted)")
                }
            }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationRepo)
                .environment(\.airRepository, airRepository)
                .environment(\.healthRepository, healthRepository)
        }
    }
}
