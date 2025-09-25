//
//  ForecastView.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import SwiftUI
import Charts

struct ForecastView: View {
    @StateObject private var ForecastVM = ForecastViewModel()
    @EnvironmentObject var locationRepo: LocationRepository
    
    var body: some View {
        NavigationStack {
            Group {
                switch ForecastVM.state {
                case .idle, .loading:
                    VStack {
                        Spacer()
                        ProgressView("Loading forecast…")
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                    
                case .failed(let error):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Failed to load forecast")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task {
                                await ForecastVM.refreshFromLocation(locationRepo.userLocation)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    
                case .loaded:
                    forecastContent
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Air Quality Forecast")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            .task {
                await ForecastVM.refreshFromLocation(locationRepo.userLocation)
            }
        }
    }
    
    // 🔹 Extraigo la UI en un ViewBuilder
    private var forecastContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Selector de rango
                Picker("Range", selection: $ForecastVM.selectedRange) {
                    Text("3 Hours").tag(3)
                    Text("8 Hours").tag(8)
                    Text("12 Hours").tag(12)
                }
                .pickerStyle(.segmented)
                .padding(.top, 8)
                
                // Forecast Chart
                VStack {
                    HStack {
                        Text("PM2.5 Forecast")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Predicted")
                            .font(.caption)
                    }
                    AQISparklineChart(
                        data: ForecastVM.forecastData,
                        chartHeight: 200,
                        showAxis: true
                    )
                }
                
                // Current conditions
                if let current = ForecastVM.currentCondition {
                    HStack {
                        VStack {
                            Text("\(current.value)")
                                .font(.largeTitle).bold()
                            Text("AQI")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        VStack {
                            Text(current.pollutant)
                                .font(.headline).bold()
                            Text(current.category)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                }
                
                // Advisory
                NotificationBanner(
                    icon: "exclamationmark.triangle.fill",
                    title: nil,
                    message: "Air quality will improve this evening. Avoid outdoor exercise between 2–4 PM when levels peak."
                )
                
                // Hourly breakdown
                Grid {
                    GridRow {
                        Text("Time")
                        Text("Category")
                        Text("AQI")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    ForEach(ForecastVM.forecastData, id: \.id) { sample in
                        GridRow {
                            Text(sample.time, style: .time)
                            Text(sample.category)
                                .foregroundStyle(.secondary)
                            Text("\(sample.value)")
                                .bold()
                        }
                        .padding(.vertical, 4)
                        Divider()
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
            }
            .padding()
        }
    }
}

#Preview {
    ForecastView()
        .environmentObject(LocationRepository())
}
