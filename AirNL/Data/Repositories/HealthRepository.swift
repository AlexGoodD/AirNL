//
//  HealthRepository.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation
import HealthKit

final class HealthRepository {
    private let healthStore = HKHealthStore()

    // Solicitar permiso
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let typesToRead: Set = [HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!]
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }

    // Obtener edad
    func getUserAge() throws -> Int {
        guard let birthDate = try? healthStore.dateOfBirthComponents().date else {
            throw NSError(domain: "HealthRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Birth date not available"])
        }
        let calendar = Calendar.current
        let age = calendar.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        return age
    }

    // Clasificar en grupo
    func getAgeGroup() throws -> String {
        let age = try getUserAge()
        switch age {
        case 0..<13: return "child"
        case 13..<60: return "adult"
        default: return "elderly"
        }
    }
}
