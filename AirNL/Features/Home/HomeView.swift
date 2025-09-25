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
    @StateObject private var HomeVM = HomeViewModel()
    @EnvironmentObject var locationRepo: LocationRepository
    
    var body: some View {
        NavigationStack {
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
                        
                        Button("View Forecast") {}
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.background))
                    .legacyShadow()
                    
                    
                    HStack(spacing: 16) {
                        SmallInfoCard(icon: "wind", title: "Wind Speed", value: "\(HomeVM.windSpeed) km/h")
                        SmallInfoCard(icon: "drop.fill", title: "Humidity", value: "\(HomeVM.humidityPercent)%")
                    }
                    
                    NotificationBanner(icon: "exclamationmark.triangle.fill", title: "Health Advisory", message: HomeVM.adviceMessage)
                    
                }
                .padding(.horizontal)
                
            }
            .onAppear {
                if let loc = locationRepo.userLocation {
                    HomeVM.refresh(lat: loc.latitude, lon: loc.longitude)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("AirNL")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            
            .toolbar {
#if os(iOS)
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let loc = locationRepo.userLocation {
                            HomeVM.refresh(lat: loc.latitude, lon: loc.longitude)
                        }
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
        .legacyShadow()
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationRepository())
}
