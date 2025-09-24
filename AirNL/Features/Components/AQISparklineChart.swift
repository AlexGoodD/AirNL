//
//  AQISparklineChart.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import Charts

// Casos: Trending Up, Trending Down, Stable

struct AQISparklineChart: View {
    var data: [AQISample]
    
    var body: some View {
        VStack (spacing: 15){
            HStack (alignment: .center) {
                Text("Last 8 hours")
                    .font(.subheadline)
                Spacer()
                // TODO: Debe ser texto variable
                Text("Trending up")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            Chart {
                ForEach(data) { sample in
                    LineMark(
                        x: .value("Time", sample.time),
                        y: .value("AQI", sample.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)
                    
                    AreaMark(
                        x: .value("Time", sample.time),
                        y: .value("AQI", sample.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue.opacity(0.1))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 60)
        }
    }
}

#Preview {
    AQISparklineChart(data: AQISample.mockData)
        .frame(height: 120)
        .padding()
}
