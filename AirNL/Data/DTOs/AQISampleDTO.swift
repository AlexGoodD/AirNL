//
//  AQISampleDTO.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation

struct AQISampleDTO: Codable {
    let pollutant: String
    let value: Double
    let aqi: Int
    let category: String
    let timestamp: String
    let source: String
    let humidity: Double?
    let wind_speed: Double?
}
