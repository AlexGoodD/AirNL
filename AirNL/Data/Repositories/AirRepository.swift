//
//  AirRepository.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import Foundation
internal import _LocationEssentials

actor AirRepository {
    static let shared = AirRepository()
    
    // MARK: Current AQ
    func fetchCurrentAQ(lat: Double, lon: Double) async throws -> AQISample {
        return try await AirAPI.fetchCurrentAQ(lat: lat, lon: lon)
    }
    
    // MARK: Forecast
    func fetchForecast(lat: Double, lon: Double, hours: Int) async throws -> [AQISample] {
        let response = try await AirAPI.fetchForecast(lat: lat, lon: lon, hours: hours)
        return response.series.map { point in
            AQISample(
                time: ISO8601DateFormatter().date(from: point.ts) ?? Date(),
                value: point.aqi,
                category: point.category,
                pollutant: point.pollutant.uppercased()
            )
        }
    }
    
    // MARK: Fetch last hours
    func fetchLastHours(lat: Double, lon: Double, hours: Int) async throws -> [AQISample] {
            let forecast = try await AirAPI.fetchForecast(lat: lat, lon: lon, hours: hours)
            return forecast.series.map { point in
                AQISample(
                    time: ISO8601DateFormatter().date(from: point.ts) ?? Date(),
                    value: point.aqi,
                    category: point.category,
                    pollutant: point.pollutant.uppercased()
                )
            }
        }
    
    // MARK: Stations
    func fetchStations(lat: Double, lon: Double) async throws -> [Station] {
        let stations = try await AirAPI.fetchStations(lat: lat, lon: lon)
        return stations.map {
            Station(
                name: $0.name,
                location: $0.location,
                distance: $0.distance,
                aqi: $0.aqi,
                category: $0.category,
                updated: $0.updated,
                coordinate: .init(latitude: $0.lat, longitude: $0.lon)
            )
        }
    }
    
    // MARK: Advice
    func fetchAdvice(ageGroup: String, activity: String, lat: Double, lon: Double) async throws -> String {
        let advice = try await AirAPI.fetchAdvice(ageGroup: ageGroup, activity: activity, lat: lat, lon: lon)
        return advice.message
    }
}
