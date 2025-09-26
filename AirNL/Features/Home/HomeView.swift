//
//  HomeView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import MapKit
import Charts

struct HomeView: View {
    
    @Environment(\.airRepository) private var repository
    
    @EnvironmentObject var locationRepo: LocationRepository
    @StateObject private var HomeVM: HomeViewModel
    
    init(repository: AirRepositoryProtocol, healthRepo: HealthRepositoryProtocol) {
        _HomeVM = StateObject(wrappedValue: HomeViewModel(
            repository: repository,
            healthRepo: healthRepo
        ))
    }
    
    @State private var showForecastModal = false

    
    
    
    var body: some View {
        NavigationStack {
            LoadingStateView(
                state: HomeVM.state,
                retry: {
                    HomeVM.refreshFromLocation(locationRepo.userLocation)
                }
            ) {
                homeContent
            }
            .scrollIndicators(.hidden)
            .navigationTitle("AirNL")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            .task {
                HomeVM.refreshFromLocation(locationRepo.userLocation)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HomeVM.refreshFromLocation(locationRepo.userLocation)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
#endif
            }
        }
    }
    
    private var homeContent: some View {
        ScrollView {
            VStack (spacing: 24) {
                VStack(spacing: 16){
                    HStack (alignment: .center) {
                        Label(HomeVM.actualLocation, systemImage: "location.fill")
                            .font(.caption)
                        Spacer()
                        Text("Updated \(HomeVM.lastUpdated, style: .time)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    AQIGaugeView(aqi: HomeVM.currentAQI)
                        .frame(height: 100)
                    
                    VStack{
                        Text(HomeVM.category)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Dominant pollutant: \(HomeVM.dominantPollutant)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    AQISparklineChart(
                        data: HomeVM.last8Hours,
                        title: "Last 8 hours",
                        subtitle: HomeVM.trendingMessage,
                        chartHeight: 60
                    )
                    
                    Button("View Forecast") {
                        showForecastModal = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .sheet(isPresented: $showForecastModal) {
                        ForecastChartModal(repository: repository)
                            .environmentObject(locationRepo)
                            .presentationDetents([.medium, .large])
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                .legacyShadow()
                
                HStack(spacing: 16) {
                    SmallInfoCard(icon: "wind", title: "Wind Speed", value: "\(HomeVM.windSpeed) km/h")
                    SmallInfoCard(icon: "drop.fill", title: "Humidity", value: "\(HomeVM.humidityPercent)%")
                }
                
                NotificationBanner(
                    icon: "exclamationmark.triangle.fill",
                    title: "Health Advisory",
                    message: HomeVM.adviceMessage
                )
            }
            .padding(.horizontal)
        }
    }
}


struct SmallInfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
            Text(title).font(.caption).foregroundColor(.secondary)
            Text(value).font(.headline).fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.background))
        .legacyShadow()
    }
}

#Preview {
    HomeView(
        repository: MockAirRepository(),
        healthRepo: MockHealthRepository()
    )
    .environmentObject(LocationRepository())
}
