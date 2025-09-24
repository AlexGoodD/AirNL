//
//  AirRepository.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import Foundation

actor AirRepository {
    static let shared = AirRepository()
    
    // TODO: Conectar con API
    private let api = "CAMBIAR"
    
    func fetchCurrentAQI() async throws -> AQISample {
        // 🚧 TODO: Llamar a API
        return AQISample(time: .now, value: Int.random(in: 50...120))
    }
    
    func fetchLastHours(hours: Int) async throws -> [AQISample] {
        // 🚧 TODO: Llamar a backend
        return AQISample.mockData
    }
}
