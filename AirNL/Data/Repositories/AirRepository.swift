//
//  AirRepository.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import Foundation
internal import _LocationEssentials

actor AirRepository: AirRepositoryProtocol {
    static let shared = AirRepository()
    
    // MARK: Current AQ
    @MainActor
    func fetchCurrentAQ(lat: Double, lon: Double) async throws -> AQISample {
        let dto = try await AirAPI.fetchCurrentAQ(lat: lat, lon: lon)
        return AQISample(
            time: ISO8601DateFormatter().date(from: dto.timestamp) ?? Date(),
            value: dto.aqi,
            category: dto.category,
            pollutant: dto.pollutant,
            humidity: dto.humidity.map { Int($0) },
            windSpeed: dto.wind_speed.map { Int($0) }
        )
    }
    
    // MARK: Forecast
    @MainActor
    func fetchForecast(lat: Double, lon: Double, hours: Int) async throws -> [AQISample] {
        let response = try await AirAPI.fetchForecast(lat: lat, lon: lon, hours: hours)
        return response.series.map { point in
            AQISample(
                time: TimeFormatters.ts.date(from: point.ts) ?? Date(),
                value: point.aqi,
                category: point.category,
                pollutant: point.pollutant.uppercased()
            )
        }
    }
    
    // MARK: Fetch last hours
    @MainActor
    func fetchLastHours(lat: Double, lon: Double, hours: Int) async throws -> [AQISample] {
        let forecast = try await AirAPI.fetchForecast(lat: lat, lon: lon, hours: hours)
        return forecast.series.map { point in
            AQISample(
                time: TimeFormatters.ts.date(from: point.ts) ?? Date(),
                value: point.aqi,
                category: point.category,
                pollutant: point.pollutant.uppercased()
            )
        }
    }
    
    // MARK: Stations
    func fetchStations(lat: Double, lon: Double) async throws -> [Station] {
        let apiStations = try await AirAPI.fetchStations(lat: lat, lon: lon)
        
        return apiStations.map { dto in
            Station(
                name: dto.name,
                location: dto.location ?? "Unknown",
                distance: dto.distance != nil
                    ? String(format: "%.1f km", dto.distance! / 1000)
                    : "N/A",
                aqi: dto.aqi,
                category: dto.category.isEmpty ? "Unknown" : dto.category,
                updated: dto.updated ?? "N/A",
                coordinate: .init(latitude: dto.lat, longitude: dto.lon)
            )
        }
    }
    
    // MARK: Advice
    func fetchAdvice(ageGroup: String, activity: String, lat: Double, lon: Double) async throws -> String {
        let advice = try await AirAPI.fetchAdvice(ageGroup: ageGroup, activity: activity, lat: lat, lon: lon)
        return advice.message
    }
}
