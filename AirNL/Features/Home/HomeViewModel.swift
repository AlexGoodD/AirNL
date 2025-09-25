//
//  HomeViewModel.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import Foundation
import Combine
import SwiftUI
import MapKit

final class HomeViewModel: ObservableObject {
    @Published var currentAQI: Int = 0
    @Published var category: String = "—"
    @Published var dominantPollutant: String = "—"
    @Published var actualLocation: String = "-"
    @Published var lastUpdated: Date = .now
    @Published var last8Hours: [AQISample] = []
    @Published var trendingMessage: String = "—"
    @Published var adviceMessage: String = "—"
    @Published var windSpeed: Int = 0
    @Published var humidityPercent: Int = 0
    
    private let repository: AirRepository
    
    init(repository: AirRepository = .shared) {
        self.repository = repository
#if DEBUG
        loadMock()
#endif
    }
    
    @MainActor
    func refresh(lat: Double, lon: Double) {
        Task {
            do {
                let latest = try await repository.fetchCurrentAQ(lat: lat, lon: lon)
                let history = try await repository.fetchLastHours(lat: lat, lon: lon, hours: 8)
                let advice = try await repository.fetchAdvice(ageGroup: "adult", activity: "commute", lat: lat, lon: lon)
                
                currentAQI = latest.value
                category = latest.category
                dominantPollutant = latest.pollutant
                lastUpdated = latest.time
                last8Hours = history
                adviceMessage = advice
                actualLocation = await resolveLocationName(lat: lat, lon: lon)
                humidityPercent = latest.humidity ?? 0
                windSpeed = latest.windSpeed ?? 0
                
            } catch {
                print("❌ Error fetching AQI: \(error)")
            }
        }
    }
    
    private func loadMock() {
        actualLocation = "Amsterdám"
        currentAQI = 72
        category = "Moderate"
        dominantPollutant = "PM2.5"
        lastUpdated = .now
        last8Hours = AQISample.mockData
        trendingMessage = "Trending Up"
        humidityPercent = 68
        windSpeed = 12
        adviceMessage = "Avoid outdoor activities if you are sensitive to pollution"
    }
}
