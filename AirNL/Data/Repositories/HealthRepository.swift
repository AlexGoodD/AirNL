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
    private let defaults = UserDefaults.standard
    private let ageKey = "userAgeGroup"

    // Solicitar permiso
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let typesToRead: Set = [HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!]
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }

    // Obtener edad de HealthKit
    private func fetchUserAge() throws -> Int {
        guard let birthDate = try? healthStore.dateOfBirthComponents().date else {
            throw NSError(
                domain: "HealthRepository",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Birth date not available"]
            )
        }
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    // Guardar grupo en UserDefaults
    func cacheAgeGroup() throws {
        let age = try fetchUserAge()
        let group: String
        switch age {
        case 0..<13: group = "child"
        case 13..<60: group = "adult"
        default: group = "elderly"
        }
        defaults.set(group, forKey: ageKey)
    }

    // Leer grupo de UserDefaults
    func getCachedAgeGroup() -> String? {
        return defaults.string(forKey: ageKey)
    }
}
