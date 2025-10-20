//
//  NetworkClientTests.swift
//  Networking
//
//  Created by Ameya on 20/10/25.
//

import XCTest
@testable import Networking

final class NetworkClientTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testNetworkClient_WhenInvalidURLIsProvided_ReturnsInvalidURLError() async {
        //Given
        let sut = NetworkClient(
            baseURL: URL(string: "https://exa mple.com")
        )
        let request = NetworkRequest(apiConfig: DummyGETAPIConfig())
        var _error: NetworkError?
        var response: String?
        
        //When
        do {
            response = try await sut.perform(request: request, response: String.self)
        } catch let error as NetworkError {
            _error = error
        } catch {
            XCTFail("When an invalid URL is provided, NetworkClient perform() should have returned NetworkError.invalidURL, but returned generic error instead.")
        }
        
        //Then
        XCTAssertEqual(_error, NetworkError.invalidURL, "When an invalid URL is provided, NetworkClient perform() should have returned NetworkError.invalidURL, but returned some other error instead.")
        XCTAssertNil(response, "When an invalid URL is provided, NetworkClient perform() should not have returned a response.")
    }
}
