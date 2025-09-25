//
//  AirAPI.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation


struct AirAPI {
    //TODO: Subir en docker para producción
    static let baseURL = URL(string: "http://10.104.33.41:8000")!
    
    // MARK: Current AQ
    static func fetchCurrentAQ(lat: Double, lon: Double) async throws -> AQISample {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("aq/current"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let decoded = try JSONDecoder().decode(AQISampleDTO.self, from: data)
        
        return AQISample(
            time: ISO8601DateFormatter().date(from: decoded.timestamp) ?? Date(),
            value: decoded.aqi,
            category: decoded.category,
            pollutant: decoded.pollutant,
            humidity: decoded.humidity.map { Int($0) },
            windSpeed: decoded.wind_speed.map { Int($0) }     
        )
    }
    
    // MARK: Forecast
    static func fetchForecast(lat: Double, lon: Double, hours: Int) async throws -> ForecastResponseDTO {
        var components = URLComponents(url: baseURL.appendingPathComponent("aq/forecast"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "hours", value: "\(hours)")
        ]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(ForecastResponseDTO.self, from: data)
    }
    
    // MARK: Stations
    static func fetchStations(lat: Double, lon: Double) async throws -> [StationDTO] {
        var components = URLComponents(url: baseURL.appendingPathComponent("aq/stations"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode([StationDTO].self, from: data)
    }
    
    // MARK: Advice
    static func fetchAdvice(ageGroup: String, activity: String, lat: Double, lon: Double) async throws -> AdviceDTO {
        let url = baseURL.appendingPathComponent("aq/advice")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "age_group": ageGroup,
            "activity": activity,
            "location": ["lat": lat, "lon": lon]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(AdviceDTO.self, from: data)
    }
}

struct AQISampleDTO: Codable {
    let pollutant: String
    let value: Double
    let aqi: Int
    let category: String
    let timestamp: String
    let source: String
    let humidity: Double?      // 👈 nuevo
    let wind_speed: Double?
}

struct ForecastResponseDTO: Codable {
    struct AQPoint: Codable {
        let ts: String
        let pollutant: String
        let value: Double
        let aqi: Int
        let category: String
        let source: String
    }
    let location: [String: Double]
    let horizon_hours: Int
    let series: [AQPoint]
}

struct StationDTO: Codable, Identifiable {
    let id: String
    let name: String
    let location: String
    let distance: String
    let aqi: Int
    let category: String
    let updated: String
    let lat: Double
    let lon: Double
}

struct AdviceDTO: Codable {
    let message: String
    let severity: String
}
