//
//  ForecastView.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import SwiftUI
import Charts

struct ForecastView: View {
    @Environment(\.airRepository) private var repository
    @EnvironmentObject var locationRepo: LocationRepository
    
    @StateObject private var ForecastVM: ForecastViewModel
    
    init() {
        _ForecastVM = StateObject(wrappedValue: ForecastViewModel(repository: AirRepository.shared))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                LoadingStateView(
                    state: ForecastVM.state,
                    retry: {
                        Task {
                            await ForecastVM.refreshFromLocation(locationRepo.userLocation)
                        }
                    }
                ) {
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
                        data: ForecastVM.sparklineData,
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
                    
                    ForEach(Array(ForecastVM.listData.enumerated()), id: \.element.id) { index, sample in
                        GridRow {
                            if index == 0 {
                                Text("Actually")
                            } else {
                                Text(localHourFormatter.string(from: sample.time))
                            }

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

private let localHourFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "h:00 a"   // 5:00 PM, 4:00 PM
    f.timeZone = TimeZone(identifier: "America/Monterrey")
    f.locale = Locale(identifier: "en_US_POSIX")
    return f
}()

#Preview {
    ForecastView()
        .environmentObject(LocationRepository())
}
