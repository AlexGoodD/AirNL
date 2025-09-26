//
//  StationDTO.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation

struct StationDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let location: String?
    let distance: Double?
    let aqi: Int
    let category: String
    let updated: String?
    let lat: Double
    let lon: Double
}
