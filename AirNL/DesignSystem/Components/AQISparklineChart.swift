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
    var title: String? = nil
    var subtitle: String? = nil
    var chartHeight: CGFloat = 60
    var showAxis: Bool = false
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 15) {
            if title != nil || subtitle != nil {
                HStack (alignment: .center) {
                    if let title = title {
                        Text(title).font(.subheadline)
                    }
                    Spacer()
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Chart {
                ForEach(data) { sample in
                    LineMark(
                        x: .value("Time", sample.time),
                        y: .value("AQI", animate ? sample.value : 0)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)
                    
                    AreaMark(
                        x: .value("Time", sample.time),
                        y: .value("AQI", animate ? sample.value : 0)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue.gradient.opacity(0.2))
                }
            }
            .chartXAxis(showAxis ? .automatic : .hidden)
            .chartYAxis(showAxis ? .automatic : .hidden)
            .frame(height: chartHeight)
            .onAppear {
                withAnimation(.easeOut(duration: 1.2)) {
                    animate = true
                }
            }
        }
    }
}

#Preview {
    AQISparklineChart(data: AQISample.mockData)
        .frame(height: 120)
        .padding()
}
