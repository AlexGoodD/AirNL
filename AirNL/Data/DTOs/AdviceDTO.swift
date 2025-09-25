//
//  AdviceDTO.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation

struct AdviceDTO: Codable {
    let aqi: Int
    let category: String
    let pollutant: String
    let value: Double
    let timestamp: String
    let message: String
    let severity: String
    let source: String
}
