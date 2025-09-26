//
//  Protocols.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import Foundation

protocol AirRepositoryProtocol {
    func fetchCurrentAQ(lat: Double, lon: Double) async throws -> AQISample
    func fetchForecast(lat: Double, lon: Double, hours: Int) async throws -> [AQISample]
    func fetchLastHours(lat: Double, lon: Double, hours: Int) async throws -> [AQISample]
    func fetchAdvice(ageGroup: String, activity: String, lat: Double, lon: Double) async throws -> String
}

protocol HealthRepositoryProtocol {
    func requestAuthorization() async throws
    func cacheAgeGroup() throws
    func getCachedAgeGroup() -> String?
}
