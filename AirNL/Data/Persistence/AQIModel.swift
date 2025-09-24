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
    
    init(time: Date, value: Int, category: String = "Moderate", pollutant: String = "PM2.5") {
        self.id = UUID()
        self.time = time
        self.value = value
        self.category = category
        self.pollutant = pollutant
    }
    
    static var mockData: [AQISample] {
        let now = Date()
        return (0..<8).map {
            AQISample(
                time: Calendar.current.date(byAdding: .hour, value: -$0, to: now)!,
                value: Int.random(in: 50...150),
                category: "Moderate",
                pollutant: "PM2.5"
            )
        }.reversed()
    }
}
