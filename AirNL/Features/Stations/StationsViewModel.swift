//
//  StationsViewModel.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import Foundation
import SwiftUI
import Combine
import MapKit

@MainActor
final class StationsViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published private(set) var state: LoadingState = .idle
    
    private let repository: any AirRepositoryProtocol
    
    private var lastLocation: (lat: Double, lon: Double)?
    private var lastUpdated: Date?
    
    init(repository: any AirRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadStations(lat: Double, lon: Double) async {
        if case .loaded = state,
           let lastUpdated,
           Date().timeIntervalSince(lastUpdated) < 600,
           lastLocation?.lat == lat,
           lastLocation?.lon == lon {
            return
        }
        
        state = .loading
        do {
            let apiStations = try await repository.fetchStations(lat: lat, lon: lon)
            self.stations = apiStations
            self.lastLocation = (lat, lon)
            self.lastUpdated = Date()
            state = .loaded
        } catch {
            print("❌ Error fetching stations: \(error)")
            self.stations = []
            state = .failed(error)
        }
    }
    
    func colorForAQI(_ value: Int) -> Color {
        switch value {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        case 151...200: return .red
        case 201...300: return .purple
        default: return .brown
        }
    }
}
