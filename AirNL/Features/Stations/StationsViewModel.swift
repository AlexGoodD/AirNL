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
    private let repository: any AirRepositoryProtocol
    
    init(repository: any AirRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadStations(lat: Double, lon: Double) async {
            do {
                self.stations = try await repository.fetchStations(lat: lat, lon: lon)
            } catch {
                print("❌ Error fetching stations: \(error)")
                self.stations = []
            }
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
