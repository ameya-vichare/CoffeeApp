// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum DateFormat: String {
    case shortDate = "E, MMM dd | h:mm a"
}

extension String {
    public func formatDate(timeZone: TimeZone = .current, dateFormat: DateFormat) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: self) else { return nil }

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.timeZone = timeZone
        outFormatter.dateFormat = dateFormat.rawValue

        let formatted = outFormatter.string(from: date)
        return formatted.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
    }
}
