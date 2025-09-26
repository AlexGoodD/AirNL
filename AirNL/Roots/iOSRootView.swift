//
//  iOSRootView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

import SwiftUI

struct iOSRootView: View {
    @Environment(\.airRepository) private var repository
    @Environment(\.healthRepository) private var healthRepo
    
    var body: some View {
        TabView {
            HomeView(repository: repository, healthRepo: healthRepo)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ForecastView(repository: repository)
                .tabItem {
                    Label("Forecast", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            StationsView(repository: repository)
                .tabItem {
                    Label("Stations", systemImage: "map.fill")
                }
        }
    }
}

#Preview {
    iOSRootView()
}
