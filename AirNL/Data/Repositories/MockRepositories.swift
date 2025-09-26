//
//  MockRepositories.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import Foundation
import MapKit

actor MockAirRepository: AirRepositoryProtocol {
    func fetchStations(lat: Double, lon: Double) async throws -> [Station] {
        return [
            Station(
                name: "Mock Centro",
                location: "Mock City",
                distance: "1.0 km",
                aqi: 50,
                category: "Good",
                updated: "Updated 2m ago",
                coordinate: .init(latitude: lat + 0.01, longitude: lon)
            ),
            Station(
                name: "Mock Norte",
                location: "Mock City",
                distance: "3.2 km",
                aqi: 120,
                category: "Unhealthy for Sensitive Groups",
                updated: "Updated 5m ago",
                coordinate: .init(latitude: lat - 0.02, longitude: lon + 0.01)
            )
        ]
    }
    
    
    @MainActor
    func fetchCurrentAQ(lat: Double, lon: Double) async throws -> AQISample {
        AQISample(time: .now, value: 72, category: "Moderate", pollutant: "PM2.5",
                  humidity: 65, windSpeed: 12)
    }

    @MainActor
    func fetchForecast(lat: Double, lon: Double, hours: Int) async throws -> [AQISample] {
        AQISample.mockData(hours: hours)
    }

    @MainActor
    func fetchLastHours(lat: Double, lon: Double, hours: Int) async throws -> [AQISample] {
        AQISample.mockData(hours: hours)
    }

    func fetchAdvice(ageGroup: String, activity: String, lat: Double, lon: Double) async throws -> String {
        "Avoid outdoor activities if you are sensitive to pollution"
    }
}

final class MockHealthRepository: HealthRepositoryProtocol {
    func requestAuthorization() async throws {}
    func cacheAgeGroup() throws {}
    func getCachedAgeGroup() -> String? { "adult" }
}
