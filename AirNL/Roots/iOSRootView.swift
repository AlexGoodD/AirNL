//
//  iOSRootView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

import SwiftUI

struct iOSRootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            StationsView()
                .tabItem {
                    Label("Stations", systemImage: "map.fill")
                }
            
            HomeView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                }
        }
    }
}

#Preview {
    iOSRootView()
}
