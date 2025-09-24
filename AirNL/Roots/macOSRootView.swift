//
//  macOSRootView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

struct macOSRootView: View {
    @State private var selection: SidebarItem? = .home
    
    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selection) { item in
                Label(item.title, systemImage: item.icon)
            }
            .listStyle(.sidebar)
        } detail: {
            switch selection {
            case .home: HomeView()
            case .forecast: ForecastView()
            case .stations: StationsView()
            case .history: HomeView()
            default: Text("Select an item")
            }
        }
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case home, forecast, stations, history
    
    var id: String { rawValue }
    var title: String {
        switch self {
        case .home: "Home"
        case .forecast: "Forecast"
        case .stations: "Stations"
        case .history: "History"
        }
    }
    var icon: String {
        switch self {
        case .home: "house.fill"
        case .forecast: "chart.line.uptrend.xyaxis"
        case .stations: "map.fill"
        case .history: "clock.arrow.trianglehead.counterclockwise.rotate.90"
        }
    }
}

#Preview {
    macOSRootView()
}
