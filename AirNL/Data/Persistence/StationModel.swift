//
//  StationModel.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation
import MapKit

struct Station: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let distance: String
    let aqi: Int
    let category: String
    let updated: String
    let coordinate: CLLocationCoordinate2D
}
