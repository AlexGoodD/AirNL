//
//  AQIGaugeView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

struct AQIGaugeView: View {
    var aqi: Int
    
    var body: some View {
        Gauge(value: Double(aqi), in: 0...500) {
            Text("AQI")
        } currentValueLabel: {
            Text("\(aqi)")
                .font(.system(size: 58, weight: .bold, design: .rounded))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(Gradient(colors: [color(for: aqi), .gray.opacity(0.2)]))
        .frame(width: 250, height: 250)
    }
    
    private func color(for value: Int) -> Color {
        switch value {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        case 151...200: return .red
        case 201...300: return .purple
        default: return .brown
        }
    }
}

#Preview {
    AQIGaugeView(aqi: 50)
}
