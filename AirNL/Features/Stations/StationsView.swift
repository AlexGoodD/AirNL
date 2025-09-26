//
//  StationsView.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import SwiftUI
import MapKit

struct StationsView: View {
    @Environment(\.airRepository) private var repository
    @EnvironmentObject private var LocRepo: LocationRepository
    
    @StateObject private var StationsVM: StationsViewModel

    init(repository: AirRepositoryProtocol) {
        _StationsVM = StateObject(wrappedValue: StationsViewModel(
            repository: repository
        ))
    }
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationStack {
            LoadingStateView(
                state: StationsVM.state,
                retry: {
                    if let coordinate = LocRepo.userLocation {
                        Task {
                            await StationsVM.loadStations(lat: coordinate.latitude, lon: coordinate.longitude)
                        }
                    }
                }
            ) {
                content
            }
            .navigationTitle("Monitoring Stations")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .task {
                if case .idle = StationsVM.state,
                   let coordinate = LocRepo.userLocation {
                    position = .region(
                        MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                    await StationsVM.loadStations(lat: coordinate.latitude, lon: coordinate.longitude)
                }
            }
        }
    }
    
    
    private var content: some View {
        VStack(spacing: 16) {
            searchBar
            
            Map(position: $position) {
                UserAnnotation()
                ForEach(StationsVM.stations) { station in
                    Annotation(station.name, coordinate: station.coordinate) {
                        Circle()
                            .fill(StationsVM.colorForAQI(station.aqi))
                            .frame(width: 20, height: 20)
                            .overlay(Circle().stroke(.white, lineWidth: 2))
                    }
                }
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
            }
            
            ScrollView {
                VStack(alignment: .leading) {
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
    }
    
    private var searchBar: some View {
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
    }
}

#Preview {
    StationsView(repository: MockAirRepository())
        .environmentObject(LocationRepository())
}
