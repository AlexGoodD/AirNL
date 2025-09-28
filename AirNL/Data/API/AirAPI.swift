//
//  AirAPI.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation


struct AirAPI {
    //TODO: Subir en docker para producción
    static let baseURL = URL(string: "http://192.168.1.118:8000")!
    
    // MARK: Current AQ
    static func fetchCurrentAQ(lat: Double, lon: Double) async throws -> AQISampleDTO {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("aq/current"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(AQISampleDTO.self, from: data)
    }
    
    // MARK: Forecast
    static func fetchForecast(lat: Double, lon: Double, hours: Int) async throws -> ForecastResponseDTO {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("aq/forecast"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "hours", value: "\(hours)")
        ]
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let raw = String(data: data, encoding: .utf8) ?? "N/A"
            throw NSError(domain: "AirAPI", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "Server error (\(httpResponse.statusCode)): \(raw)"
            ])
        }
        
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
