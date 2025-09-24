//
//  ForecastView.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
// Test

import SwiftUI
import Charts

struct ForecastView: View {
    @State private var selectedRange = 3
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Selector de rango
                    Picker("Range", selection: $selectedRange) {
                        Text("3 Hours").tag(3)
                        Text("8 Hours").tag(8)
                        Text("12 Hours").tag(12)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)
                    
                    // Forecast Chart
                    VStack{
                        HStack {
                            Text("PM2.5 Forecast")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("Predicted")
                                .font(.caption)
                        }
                        AQISparklineChart(
                            data: AQISample.mockData,
                            chartHeight: 200,
                            showAxis: true
                        )
                    }
                    
                    // Current conditions
                    HStack {
                        VStack {
                            Text("78")
                                .font(.largeTitle).bold()
                            Text("AQI")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        VStack {
                            Text("32")
                                .font(.largeTitle).bold()
                            Text("PM2.5 μg/m³")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    
                    // Advisory
                    Label {
                        Text("Air quality will improve this evening. Avoid outdoor exercise between 2–4 PM when levels peak.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title3)
                            .foregroundColor(.yellow)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    
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
                        
                        ForEach(AQISample.mockData, id: \.id) { sample in
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
                    
                    // Actions
                    VStack(spacing: 12) {
                        Button {
                            // set alert
                        } label: {
                            Label("Set Alert", systemImage: "bell.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)


                        Button {
                            // share
                        } label: {
                            Label("Share Forecast", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)

                    }
                }
                .padding()
            }
            .navigationTitle("Air Quality Forecast")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
        }
    }
}

#Preview {
    ForecastView()
}
