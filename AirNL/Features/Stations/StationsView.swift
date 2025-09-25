//
//  StationsView.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import SwiftUI
import MapKit

struct StationsView: View {
    @StateObject private var StationsVM = StationsViewModel()
    @StateObject private var LocRepo = LocationRepository()
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    Text("Search stations or locations")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top, 8)
                
                Map(position: $position) {
                    UserAnnotation()
                    
                    ForEach(StationsVM.stations) { station in
                        Annotation(station.name, coordinate: station.coordinate) {
                            Circle()
                                .fill(StationsVM.colorForAQI(station.aqi))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle().stroke(.white, lineWidth: 2)
                                )
                        }
                    }
                }
                .mapStyle(.standard)
                .mapControls {
                    MapUserLocationButton()
                }
                .task {
                    if let coordinate = LocRepo.userLocation {
                        position = .region(
                            MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        )
                    }
                }
                
                ScrollView {
                    VStack (alignment: .leading){
                        Text("Nearby Stations")
                            .font(.headline)
                        LazyVStack(spacing: 12) {
                            ForEach(StationsVM.stations) { station in
                                StationCard(station: station, color: StationsVM.colorForAQI(station.aqi))
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                
            }
            .navigationTitle("Monitoring Stations")
#if os(ios)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

struct StationCard: View {
    let station: StationsViewModel.Station
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.85))
                    .frame(width: 52, height: 52)
                Text("\(station.aqi)")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(station.name)
                    .font(.headline)
                Text(station.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(station.distance)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(station.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(station.updated)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    StationsView()
        .environmentObject(LocationRepository())

}
