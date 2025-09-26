//
//  TimeFormatters.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import Foundation

struct TimeFormatters {
    static let localHour: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h a" // 5 PM, 4 PM
        f.timeZone = .current
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    static let ts: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm"
        f.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
}
