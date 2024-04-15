//
//  String.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import Foundation

extension Optional where Wrapped == String {
    func humanReadableDate() -> String {
        guard let strongSelf = self else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set locale to ensure the formatter is not affected by the device's locale
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Set timezone to UTC
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: strongSelf) {
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
