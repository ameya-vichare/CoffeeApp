//
//  NetworkClientTests.swift
//  Networking
//
//  Created by Ameya on 20/10/25.
//

import XCTest
@testable import Networking

final class NetworkClientTests: XCTestCase {
    var sut: NetworkClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testNetworkClient_WhenGivenValidServerResponse_ReturnsValidParsedType() async {
        //Given
        sut = NetworkClient(
            baseURL: URL(string: "https://example.com"),
            session: URLSessionStub.getURLSessionStub(dataStr: "{\"status\": \"ok\"}")
        )
        
        let request = NetworkRequest(apiConfig: DummyGETAPIConfig())
        var response: [String: String]?
        
        //When
        do {
            response = try await sut.perform(request: request, response: [String: String].self)
        } catch {
            XCTFail("When valid response is provided, NetworkClient perform() should not have returned an error.")
        }
        
        //Then
        XCTAssertNotNil(response, "When valid response is provided, NetworkClient perform() should have returned a valid parsed type.")
        XCTAssertEqual(response, ["status": "ok"], "When valid response is provided, NetworkClient perform() should have returned a parsed type.")
    }
    
    func testNetworkClient_WhenGivenInvalidResponseParseType_ReturnsDecodingError() async {
        //Given
        sut = NetworkClient(
            baseURL: URL(string: "https://example.com"),
            session: URLSessionStub.getURLSessionStub(dataStr: "{\"status\": \"ok\"}")
        )

        let request = NetworkRequest(apiConfig: DummyGETAPIConfig())
        var response: String?
        var _error: NetworkError?
        
        //When
        do {
            response = try await sut.perform(request: request, response: String.self)
        } catch let error as NetworkError {
            _error = error
        } catch {
            XCTFail("When given an invalid response parse type, NetworkClient perform() should have returned a NetworkError.decodingError, but returned another error instead")
        }
        
        //Then
        XCTAssertNil(response, "When given an invalid response parse type, NetworkClient perform() should not return a response.")
        XCTAssertEqual(_error, NetworkError.decodingError(errorDescription: "A localized description"), "When given an invalid response parse type, NetworkClient perform() should have returned a NetworkError.decodingError but it returned some other error instead.")
    }
    
    func testNetworkClient_WhenInvalidURLIsProvided_ReturnsInvalidURLError() async {
        //Given
        let sut = NetworkClient(
            baseURL: URL(string: "https://exa mple.com"),
            session: URLSessionStub.getURLSessionStub()
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
    
    func testNetworkClient_WhenAPICallIsCancelled_ReturnsCancelledError() async {
        // Given
        sut = NetworkClient(
            baseURL: URL(string: "https://example.com"),
            session: URLSessionStub.getURLSessionStub(error: URLError(.cancelled))
        )
        
        let request = NetworkRequest(apiConfig: DummyGETAPIConfig())
        var response: [String: String]?
        var _error: NetworkError?
        
        // When
        do {
            response = try await sut.perform(request: request, response: [String: String].self)
        } catch let error as NetworkError {
            _error = error
        } catch {
            XCTFail("When an API call is cancelled, NetworkClient perform() should have returned a NetworkError.cancelled, but returned another error instead")
        }
        
        // Then
        XCTAssertEqual(_error, NetworkError.cancelled, "When an API call is cancelled, NetworkClient perform() should have returned a NetworkError.cancelled, but returned another error instead")
        XCTAssertNil(response, "When an API call is cancelled, NetworkClient perform() should not have returned a response.")
    }
    
    func testNetworkClient_WhenGivenBadServerResponse_ReturnsRequestFailedError() async {
        // Given
        sut = NetworkClient(
            baseURL: URL(string: "https://example.com"),
            session: URLSessionStub.getURLSessionStub(error: URLError(.badServerResponse))
        )
        
        let request = NetworkRequest(apiConfig: DummyGETAPIConfig())
        var response: [String: String]?
        var _error: NetworkError?
        
        // When
        do {
            response = try await sut.perform(request: request, response: [String: String].self)
        } catch let error as NetworkError {
            _error = error
        } catch {
            XCTFail("When an API call is cancelled, NetworkClient perform() should have returned a NetworkError.urlError, but returned another error instead")
        }
        
        // Then
        XCTAssertEqual(_error, NetworkError.requestFailed(errorDescription: "A localised error description"), "When an API call is cancelled, NetworkClient perform() should have returned a NetworkError.urlError, but returned another error instead")
        XCTAssertNil(response, "When an API call is cancelled, NetworkClient perform() should not have returned a response.")
    }
    
    func testNetworkClient_WhenGiven500StatusCode_ReturnsInvalidResponseError() async {
        // Given
        sut = NetworkClient(
            baseURL: URL(string: "https://example.com"),
            session: URLSessionStub.getURLSessionStub(statusCode: 500)
        )
        
        let request = NetworkRequest(apiConfig: DummyGETAPIConfig())
        var response: [String: String]?
        var _error: NetworkError?
        
        // When
        do {
            response = try await sut.perform(request: request, response: [String: String].self)
        } catch let error as NetworkError {
            _error = error
        } catch {
            XCTFail("When a 500 status code is received, NetworkClient perform() should have returned a NetworkError.invalidResponse")
        }
        
        // Then
        XCTAssertEqual(_error, NetworkError.invalidResponse(statusCode: 500, data: nil), "When a non 200 status code is received, NetworkClient perform() should have returned a NetworkError.invalidResponse")
        XCTAssertEqual(_error?.statusCode, 500, "When a 500 status code is received, NetworkClient perform() should have returned a 500 status code")
        XCTAssertNil(response, "When a 500 status code is received, NetworkClient perform() should not have returned a response")
    }
    
    // TODO: Test forming of URLRequest - right/wrong method, right/wrong query params, headers, body, encoding params
    
    // TODO: Test invalid server response returns apt error
    
    
}
