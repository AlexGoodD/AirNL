//
//  StationCard.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import SwiftUI
internal import _LocationEssentials

struct StationCard: View {
    let station: Station
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // AQI Badge
            Circle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.95), color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)
                .overlay(
                    Text("\(station.aqi)")
                        .font(.headline).bold()
                        .foregroundColor(.white)
                )
            
            // Info principal
            VStack(alignment: .leading, spacing: 6) {
                Text(station.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(station.location)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Text(station.distance)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Info lateral
            VStack(alignment: .trailing, spacing: 6) {
                Text(station.category)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Text(station.updated)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background)
        )
        .legacyShadow()
    }
}

#Preview {
    VStack(spacing: 12) {
        StationCard(
            station: Station(
                name: "Centro",
                location: "Monterrey, Nuevo León",
                distance: "1.0 km",
                aqi: 45,
                category: "Good",
                updated: "Updated 2m ago",
                coordinate: .init(latitude: 25.67, longitude: -100.31)
            ),
            color: .green
        )
        
        StationCard(
            station: Station(
                name: "San Nicolás",
                location: "San Nicolás de los Garza, Nuevo León",
                distance: "3.2 km",
                aqi: 85,
                category: "Moderate",
                updated: "Updated 5m ago",
                coordinate: .init(latitude: 25.75, longitude: -100.28)
            ),
            color: .yellow
        )
        
        StationCard(
            station: Station(
                name: "La Pastora",
                location: "Guadalupe, Nuevo León",
                distance: "6.5 km",
                aqi: 120,
                category: "Unhealthy for Sensitive Groups",
                updated: "Updated 10m ago",
                coordinate: .init(latitude: 25.66, longitude: -100.24)
            ),
            color: .orange
        )
        
        StationCard(
            station: Station(
                name: "Obispado",
                location: "Monterrey, Nuevo León",
                distance: "2.5 km",
                aqi: 170,
                category: "Unhealthy",
                updated: "Updated 15m ago",
                coordinate: .init(latitude: 25.68, longitude: -100.34)
            ),
            color: .red
        )
        
        StationCard(
            station: Station(
                name: "Apodaca",
                location: "Apodaca, Nuevo León",
                distance: "9.8 km",
                aqi: 250,
                category: "Very Unhealthy",
                updated: "Updated 30m ago",
                coordinate: .init(latitude: 25.77, longitude: -100.19)
            ),
            color: .purple
        )
        
        StationCard(
            station: Station(
                name: "Santa Catarina",
                location: "Santa Catarina, Nuevo León",
                distance: "15.0 km",
                aqi: 400,
                category: "Hazardous",
                updated: "Updated 1h ago",
                coordinate: .init(latitude: 25.67, longitude: -100.45)
            ),
            color: .brown
        )
    }
    .padding()
}
