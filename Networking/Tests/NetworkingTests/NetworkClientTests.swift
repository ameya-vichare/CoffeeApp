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
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testNetworkClient_WhenGivenValidServerResponse_ReturnsValidJSON() async {
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
        XCTAssertNotNil(response, "When valid response is provided, NetworkClient perform() should have returned a valid JSON.")
        XCTAssertEqual(response, ["status": "ok"], "When valid response is provided, NetworkClient perform() should have returned a valid JSON.")
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
        } catch {}
        
        //Then
        XCTAssertNil(response, "When given an invalid response parse type, NetworkClient perform() should not return a response.")
        XCTAssertEqual(_error, NetworkError.decodingError(errorDescription: "A localized description"), "When given an invalid response parse type, NetworkClient perform() should have returned decodingError but it returned some other error instead.")
        
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
}
