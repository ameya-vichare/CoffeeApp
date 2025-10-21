//
//  File.swift
//  Networking
//
//  Created by Ameya on 20/10/25.
//

import Foundation

public final class URLSessionStub: URLSessionProtocol {
    let stubbedData: Data
    let stubbedResponse: URLResponse
    let stubbedError: Error?
    
    init(stubbedData: Data, stubbedResponse: URLResponse, stubbedError: Error?) {
        self.stubbedData = stubbedData
        self.stubbedResponse = stubbedResponse
        self.stubbedError = stubbedError
    }
    
    public func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if let stubbedError {
            throw stubbedError
        } else {
            return (stubbedData, stubbedResponse)
        }
    }
    
    static func getURLSessionStub(
        dataStr: String = "",
        statusCode: Int = 200,
        error: Error? = nil
    ) -> URLSessionStub {
        let stubbedData = dataStr.data(using: .utf8)
        let stubbedResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        return URLSessionStub(
            stubbedData: stubbedData!,
            stubbedResponse: stubbedResponse!,
            stubbedError: error
        )
    }
}
