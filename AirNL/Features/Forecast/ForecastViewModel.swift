//
//  ForecastViewModel.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import Foundation
import Combine
import MapKit
import SwiftUI

@MainActor
final class ForecastViewModel: ObservableObject {
    // MARK: - Published state
    @Published var selectedRange: Int = 3 {
        didSet { updateSparkline() }
    }
    @Published private(set) var allData: [AQISample] = []       
    @Published private(set) var sparklineData: [AQISample] = []
    @Published private(set) var listData: [AQISample] = []
    @Published private(set) var currentCondition: AQISample?
    @Published private(set) var state: LoadingState = .idle

    private let repository: any AirRepositoryProtocol
    private var lastLocation: (lat: Double, lon: Double)?

    init(repository: any AirRepositoryProtocol) {
        self.repository = repository
    }

    func refreshFromLocation(_ location: CLLocationCoordinate2D?) async {
        guard let loc = location else { return }
        await refresh(lat: loc.latitude, lon: loc.longitude)
    }

    func refresh(lat: Double, lon: Double) async {
        lastLocation = (lat, lon)
        await loadForecast(lat: lat, lon: lon)
    }

    private func loadForecast(lat: Double, lon: Double) async {
        state = .loading
        do {
            let forecast = try await repository.fetchForecast(lat: lat, lon: lon, hours: 24)
            applyForecast(forecast)
            state = .loaded
        } catch {
            state = .failed(error)
            print("❌ Error fetching forecast: \(error)")
        }
    }

    private func applyForecast(_ forecast: [AQISample]) {
        allData = forecast.sorted { $0.time < $1.time }

        currentCondition = allData.first
        updateSparkline()
        listData = Array(allData.prefix(10))
    }

    private func updateSparkline() {
        sparklineData = Array(allData.prefix(selectedRange))
    }
}
