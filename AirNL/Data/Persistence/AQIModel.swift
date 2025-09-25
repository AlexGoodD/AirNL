//
//  AQIModel.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftData
import Foundation

@Model
final class AQISample {
    @Attribute(.unique) var id: UUID
    var time: Date
    var value: Int
    var category: String
    var pollutant: String
    var humidity: Int?
    var windSpeed: Int?
    
    init(
        time: Date,
        value: Int,
        category: String = "Moderate",
        pollutant: String = "PM2.5",
        humidity: Int? = nil,
        windSpeed: Int? = nil
    ) {
        self.id = UUID()
        self.time = time
        self.value = value
        self.category = category
        self.pollutant = pollutant
        self.humidity = humidity
        self.windSpeed = windSpeed
    }
    
    static var mockData: [AQISample] {
        let now = Date()
        return (0..<8).map {
            AQISample(
                time: Calendar.current.date(byAdding: .hour, value: -$0, to: now)!,
                value: Int.random(in: 50...150),
                category: "Moderate",
                pollutant: "PM2.5",
                humidity: 68,
                windSpeed: 12
            )
        }.reversed()
    }
}

extension AQISample {
    static func mockData(hours: Int) -> [AQISample] {
        let now = Date()
        return (0..<hours).map { i in
            AQISample(
                time: Calendar.current.date(byAdding: .hour, value: i, to: now)!,
                value: Int.random(in: 20...(50 + hours * 15)), // rango cambia según horas
                category: ["Good", "Moderate", "Unhealthy"].randomElement()!,
                pollutant: "PM2.5",
                humidity: Int.random(in: 40...80),
                windSpeed: Int.random(in: 0...20)
            )
        }
    }
}
