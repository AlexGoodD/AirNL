//
//  MockRepositories.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import Foundation

actor MockAirRepository: AirRepositoryProtocol {
    
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
