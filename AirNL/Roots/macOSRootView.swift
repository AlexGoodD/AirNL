//
//  macOSRootView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

struct macOSRootView: View {
    @State private var selection: SidebarItem? = .home
    @Environment(\.airRepository) private var repository
    @Environment(\.healthRepository) private var healthRepo
    
    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selection) { item in
                Label(item.title, systemImage: item.icon)
            }
            .listStyle(.sidebar)
        } detail: {
            switch selection {
            case .home: HomeView(repository: repository, healthRepo: healthRepo)
            case .forecast: ForecastView(repository: repository)
            case .stations: StationsView(repository: repository)
            default: Text("Select an item")
            }
        }
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case home, forecast, stations
    
    var id: String { rawValue }
    var title: String {
        switch self {
        case .home: "Home"
        case .forecast: "Forecast"
        case .stations: "Stations"
        }
    }
    var icon: String {
        switch self {
        case .home: "house.fill"
        case .forecast: "chart.line.uptrend.xyaxis"
        case .stations: "map.fill"
        }
    }
}

#Preview {
    macOSRootView()
}
