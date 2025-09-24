//
//  ForecastViewModel.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import Foundation
import Combine
import SwiftUI

final class ForecastViewModel: ObservableObject {
    @Published var selectedRange: Int = 3  // 3, 8 o 12 horas
    @Published var forecastData: [AQISample] = []
    @Published var currentCondition: AQISample?
    
    private let repository: AirRepository
    
    init(repository: AirRepository = AirRepository.shared) {
        self.repository = repository
        loadMock()
    }
    
    @MainActor
    func refresh() {
        Task {
            do {
                let forecast = try await repository.fetchForecast(hours: selectedRange)
                forecastData = forecast
                currentCondition = forecast.first
            } catch {
                print("❌ Error fetching forecast: \(error)")
            }
        }
    }
    
    private func loadMock() {
        forecastData = AQISample.mockData
        currentCondition = forecastData.first
    }
}
