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

    private let airRepository: AirRepositoryProtocol
    private let healthRepository: HealthRepositoryProtocol

    init() {
        #if DEBUG
        // 👉 Al correr en simulador o debug, usas mocks
        airRepository = MockAirRepository()
        healthRepository = MockHealthRepository()
        #else
        // 👉 En build Release (App Store/TestFlight), usas los reales
        airRepository = AirRepository.shared
        healthRepository = HealthRepository()
        #endif
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
