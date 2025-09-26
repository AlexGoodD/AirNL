//
//  HomeViewModel.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import Foundation
import Combine
import SwiftUI
import MapKit

final class HomeViewModel: ObservableObject {
    @Published var currentAQI: Int = 0
    @Published var category: String = "—"
    @Published var dominantPollutant: String = "—"
    @Published var actualLocation: String = "-"
    @Published var lastUpdated: Date = .now
    @Published var last8Hours: [AQISample] = []
    @Published var trendingMessage: String = "—"
    @Published var adviceMessage: String = "—"
    @Published var windSpeed: Int = 0
    @Published var humidityPercent: Int = 0
    @Published var state: LoadingState = .idle
    
    private let repository: AirRepositoryProtocol
    private let healthRepo: HealthRepositoryProtocol
    
    
    init(
        repository: AirRepositoryProtocol,
        healthRepo: HealthRepositoryProtocol
    ) {
        self.repository = repository
        self.healthRepo = healthRepo
    }
    
    @MainActor
    func refreshFromLocation(_ location: CLLocationCoordinate2D?) {
        guard let loc = location else { return }
        refresh(lat: loc.latitude, lon: loc.longitude)
    }
    
    @MainActor
    func refresh(lat: Double, lon: Double) {
        Task {
            state = .loading
            do {
                let ageGroup = try await resolveAgeGroup()
                let latest = try await fetchLatestAQI(lat: lat, lon: lon)
                let history = try await fetchHistory(lat: lat, lon: lon)
                let advice = try await fetchAdvice(ageGroup: ageGroup, lat: lat, lon: lon)
                let locationName = await resolveLocationName(lat: lat, lon: lon)
                
                applyData(
                    latest: latest,
                    history: history,
                    advice: advice,
                    location: locationName
                )
                
                state = .loaded
            } catch {
                print("❌ Error fetching AQI: \(error)")
                state = .failed(error)
            }
        }
    }
    
    private func resolveAgeGroup() async throws -> String {
#if targetEnvironment(simulator)
        return "adult" // fallback en simulador
#else
        if let cached = healthRepo.getCachedAgeGroup() {
            return cached
        }
        try await healthRepo.requestAuthorization()
        try healthRepo.cacheAgeGroup()
        return healthRepo.getCachedAgeGroup() ?? "adult"
#endif
    }
    
    private func fetchLatestAQI(lat: Double, lon: Double) async throws -> AQISample {
        return try await repository.fetchCurrentAQ(lat: lat, lon: lon)
    }
    
    private func fetchHistory(lat: Double, lon: Double) async throws -> [AQISample] {
        return try await repository.fetchLastHours(lat: lat, lon: lon, hours: 8)
    }
    
    private func fetchAdvice(ageGroup: String, lat: Double, lon: Double) async throws -> String {
        return try await repository.fetchAdvice(ageGroup: ageGroup, activity: "commute", lat: lat, lon: lon)
    }
    
    @MainActor
    private func applyData(latest: AQISample, history: [AQISample], advice: String, location: String) {
        currentAQI = latest.value
        category = latest.category
        dominantPollutant = latest.pollutant
        lastUpdated = latest.time
        last8Hours = history
        trendingMessage = computeTrendingMessage(from: history)
        adviceMessage = advice
        actualLocation = location
        humidityPercent = latest.humidity ?? 0
        windSpeed = latest.windSpeed ?? 0
    }
    
    //TODO: Mejorar actualmente solo compara primer y último valor
    private func computeTrendingMessage(from samples: [AQISample]) -> String {
        guard samples.count >= 2 else { return "—" }
        
        let first = samples.first!.value
        let last = samples.last!.value
        let diff = last - first
        let threshold = 5
        
        switch diff {
        case let d where d > threshold: return "Trending Up"
        case let d where d < -threshold: return "Trending Down"
        default: return "Stable"
        }
    }
}
