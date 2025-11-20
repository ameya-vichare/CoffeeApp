// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class AppConfiguration {
    public init() {}
    
    public lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String else {
            fatalError("apiKey not found in Info.plist")
        }
        return apiKey
    }()
    
    public lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "apiBaseURL") as? String else {
            fatalError("apiBaseURL not found in Info.plist")
        }
        return apiBaseURL
    }()
}
