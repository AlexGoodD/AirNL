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
        didSet { Task { await refreshIfPossible(skipStateUpdate: true) } }
    }
    @Published private(set) var forecastData: [AQISample] = []
    @Published private(set) var currentCondition: AQISample?
    @Published private(set) var state: LoadingState = .idle
    
    // MARK: - Dependencies
    private let repository: AirRepository
    private var lastLocation: (lat: Double, lon: Double)?
    
    // MARK: - Init
    init(repository: AirRepository = .shared) {
        self.repository = repository
#if DEBUG
        loadMock()
#endif
    }
    
    // MARK: - Public API
    func refreshFromLocation(_ location: CLLocationCoordinate2D?) async {
        guard let loc = location else { return }
        await refresh(lat: loc.latitude, lon: loc.longitude)
    }
    
    func refresh(lat: Double, lon: Double) async {
        lastLocation = (lat, lon)
        await loadForecast(lat: lat, lon: lon, updateState: true)
    }
    
    // MARK: - Private helpers
    private func refreshIfPossible(skipStateUpdate: Bool = false) async {
        guard let loc = lastLocation else { return }
        await loadForecast(lat: loc.lat, lon: loc.lon, updateState: !skipStateUpdate)
    }
    
    private func loadForecast(lat: Double, lon: Double, updateState: Bool) async {
    #if DEBUG
        forecastData = AQISample.mockData(hours: selectedRange)
        currentCondition = forecastData.first
        state = .loaded
        return
    #else
        if updateState { state = .loading }
        do {
            let forecast = try await repository.fetchForecast(lat: lat, lon: lon, hours: selectedRange)
            applyForecast(forecast)
            if updateState { state = .loaded }
        } catch {
            if updateState { state = .failed(error) }
            print("❌ Error fetching forecast: \(error)")
        }
    #endif
    }
    
    private func applyForecast(_ forecast: [AQISample]) {
        forecastData = forecast
        currentCondition = forecast.first
    }
    
    private func loadMock() {
        forecastData = AQISample.mockData(hours: selectedRange)
        currentCondition = forecastData.first
        state = .loaded
    }
}

// MARK: - View state
enum LoadingState {
    case idle
    case loading
    case loaded
    case failed(Error)
}
