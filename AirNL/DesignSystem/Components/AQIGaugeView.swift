//
//  AQIGaugeView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

struct AQIGaugeView: View {
    var aqi: Int
    
    @State private var animatedProgress: Double = 0
    @State private var displayedAQI: Int = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.2),
                    lineWidth: 10
                )
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color(for: aqi),
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.5), value: animatedProgress)
            
            VStack {
                Text("\(displayedAQI)")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
                    .animation(.easeOut(duration: 1.5), value: displayedAQI)
                Text("AQI")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 100, height: 100)
        .onAppear {
            animatedProgress = 0
            displayedAQI = 0
            
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 1.5)) {
                    animatedProgress = Double(aqi) / 500.0
                    displayedAQI = aqi
                }
            }
        }
        .onChange(of: aqi) { _, newValue in
            withAnimation(.easeOut(duration: 1.5)) {
                animatedProgress = Double(newValue) / 500.0
                displayedAQI = newValue
            }
        }
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
    AQIGaugeView(aqi: 230)
}
