//
//  HomeView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import Charts

struct HomeView: View {
    @StateObject private var HomeVM = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 24) {
                    VStack(spacing: 16) {
                        HStack (alignment: .center) {
                            Label("Amsterdam", systemImage: "location.fill")
                                .font(.caption)
                            Spacer()
                            Text("Updated 10:15 AM")
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
                            subtitle: "Trending up",
                            chartHeight: 60
                        )
                        
                        Button("View Forecast") {}
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    
                    HStack(spacing: 16) {
                        SmallInfoCard(icon: "wind", title: "Wind Speed", value: "12 km/h")
                        SmallInfoCard(icon: "drop.fill", title: "Humidity", value: "68%")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Health Advisory", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline)
                        Text("Avoid outdoor activities if you are sensitive to pollution.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemYellow).opacity(0.2)))
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("AirNL")
            
            .toolbar {
#if os(iOS)
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HomeVM.refresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
#endif
            }
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
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    HomeView()
}
