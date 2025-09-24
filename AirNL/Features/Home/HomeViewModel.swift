//
//  HomeViewModel.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var currentAQI: Int = 0
    @Published var category: String = "—"
    @Published var dominantPollutant: String = "—"
    @Published var lastUpdated: Date = .now
    @Published var last8Hours: [AQISample] = []
    
    private let repository: AirRepository
    
    init(repository: AirRepository = AirRepository.shared) {
        self.repository = repository
        loadMock()
    }
    
    @MainActor
    func refresh() {
        Task {
            do {
                let latest = try await repository.fetchCurrentAQI()
                let history = try await repository.fetchLastHours(hours: 8)
                
                currentAQI = latest.value
                category = latest.category
                dominantPollutant = latest.pollutant
                lastUpdated = latest.time
                last8Hours = history
            } catch {
                print("❌ Error fetching AQI: \(error)")
            }
        }
    }
    
    private func loadMock() {
        currentAQI = 72
        category = "Moderate"
        dominantPollutant = "PM2.5"
        lastUpdated = .now
        last8Hours = AQISample.mockData
    }
}
