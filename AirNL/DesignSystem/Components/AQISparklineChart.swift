//
//  AQISparklineChart.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI
import Charts

struct AQISparklineChart: View {
    var data: [AQISample]
    var title: String? = nil
    var subtitle: String? = nil
    var chartHeight: CGFloat = 60
    var showAxis: Bool = false
    
    @State private var animateProgress: CGFloat = 0.0
    
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
                        y: .value("AQI", sample.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.clear)
                }
            }
            .chartXAxis(showAxis ? .automatic : .hidden)
            .chartYAxis(showAxis ? .automatic : .hidden)
            .chartYScale(domain: 0...400)
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Path { path in
                        guard data.count > 1 else { return }
                        
                        // Convertir valores de datos → coordenadas de plot
                        let points = data.enumerated().map { index, sample -> CGPoint in
                            let xPos = proxy.position(forX: sample.time) ?? 0
                            let yPos = proxy.position(forY: sample.value) ?? 0
                            return CGPoint(x: xPos, y: yPos)
                        }
                        
                        path.addLines(points)
                    }
                    .trim(from: 0, to: animateProgress)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                    .animation(.easeOut(duration: 1.5), value: animateProgress)
                }
            }
            .transaction { t in
                t.animation = nil
            }
            .frame(height: chartHeight)
            .onAppear {
                animateProgress = 0.0
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 1.5)) {
                        animateProgress = 1.0
                    }
                }
            }
        }
    }
}

#Preview {
    AQISparklineChart(data: AQISample.mockData, showAxis: true)
        .frame(height: 150)
        .padding()
}
