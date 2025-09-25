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
    let location: [String: Double]
    let horizon_hours: Int
    let series: [AQPoint]
}
