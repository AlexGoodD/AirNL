//
//  LocationName.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import CoreLocation

func resolveLocationName(lat: Double, lon: Double) async -> String {
    let location = CLLocation(latitude: lat, longitude: lon)
    let geocoder = CLGeocoder()

    do {
        if let placemark = try await geocoder.reverseGeocodeLocation(location).first {
            return placemark.locality ?? placemark.administrativeArea ?? "-"
        }
    } catch {
        print("❌ Reverse geocoding failed: \(error)")
    }

    return "-"
}
