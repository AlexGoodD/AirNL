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
    
    struct Station: Identifiable {
        let id = UUID()
        let name: String
        let location: String
        let distance: String
        let aqi: Int
        let category: String
        let updated: String
        let coordinate: CLLocationCoordinate2D
    }
    
    @Published var stations: [Station] = []
    
    init() {
        loadMockStations()
    }
    
    private func loadMockStations() {
        stations = [
            Station(
                name: "Amsterdam Centrum",
                location: "Nieuwmarkt",
                distance: "0.8 km away",
                aqi: 42,
                category: "Good",
                updated: "Updated 2m ago",
                coordinate: CLLocationCoordinate2D(latitude: 52.3727598, longitude: 4.8936041)
            ),
            Station(
                name: "Amsterdam Noord",
                location: "NDSM Werf",
                distance: "2.1 km away",
                aqi: 78,
                category: "Moderate",
                updated: "Updated 5m ago",
                coordinate: CLLocationCoordinate2D(latitude: 52.400997, longitude: 4.892189)
            )
        ]
    }
    
    func colorForAQI(_ value: Int) -> Color {
        switch value {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .red
        }
    }
}
