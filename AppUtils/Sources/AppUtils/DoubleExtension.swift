//
//  DoubleExtensions.swift
//  AppUtils
//
//  Created by Ameya on 25/10/25.
//
import Foundation

extension Double {
    public func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
