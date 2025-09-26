//
//  ForecastResponseDTO.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation

struct ForecastResponseDTO: Codable {
    struct AQPoint: Codable {
        let ts: String
        let pollutant: String
        let value: Double
        let aqi: Int
        let category: String
        let source: String
    }
    
    struct Location: Codable {
        let lat: Double
        let lon: Double
    }
    
    let location: Location
    let horizon_hours: Int
    let series: [AQPoint]
}

extension ForecastResponseDTO.AQPoint {
    var date: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(identifier: "America/Monterrey") // 👈 forzar
        return formatter.date(from: ts) ?? Date()
    }
}
