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
        let randomValue = [45, 85, 120, 170, 250, 400].randomElement()!
        let category: String
        switch randomValue {
        case 0...50: category = "Good"
        case 51...100: category = "Moderate"
        case 101...150: category = "Unhealthy for Sensitive Groups"
        case 151...200: category = "Unhealthy"
        case 201...300: category = "Very Unhealthy"
        default: category = "Hazardous"
        }
        return AQISample(time: .now, value: randomValue, category: category,
                         pollutant: "PM2.5", humidity: 65, windSpeed: 12)
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
