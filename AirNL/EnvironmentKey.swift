//
//  EnvironmentKey.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import Foundation
import SwiftUI

private struct AirRepositoryKey: EnvironmentKey {
    static let defaultValue: any AirRepositoryProtocol = AirRepository.shared
}

extension EnvironmentValues {
    var airRepository: any AirRepositoryProtocol {
        get { self[AirRepositoryKey.self] }
        set { self[AirRepositoryKey.self] = newValue }
    }
}

private struct HealthRepositoryKey: EnvironmentKey {
    static let defaultValue: any HealthRepositoryProtocol = HealthRepository()
}

extension EnvironmentValues {
    var healthRepository: any HealthRepositoryProtocol {
        get { self[HealthRepositoryKey.self] }
        set { self[HealthRepositoryKey.self] = newValue }
    }
}
