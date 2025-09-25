//
//  StationDTO.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation

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
