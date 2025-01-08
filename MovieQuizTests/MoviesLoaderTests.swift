//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Vladimir on 08.01.2025.
//

import XCTest

@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    
    func testSuccesLoading() throws {
//        given
        let stubClient: NetworkRouting = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubClient)
        let expectation = expectation(description: "waiting for movies")
        loader.loadMovies { result in
//            then
            switch result {
            case .success(let result):
                XCTAssertNotNil(result)
                XCTAssertEqual(result.items.count, 2)
            case .failure(let error):
                XCTFail("This loader shouldn't fail")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testFailureLoading() throws {
//        given
        let stubClient: NetworkRouting = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubClient)
        let expectation = expectation(description: "waiting for movies")
        loader.loadMovies { result in
//            then
            switch result {
            case .success(let result):
                XCTFail("This loader should fail")
            case .failure(let error):
                XCTAssertEqual(error as? StubNetworkClient.TestErrors, StubNetworkClient.TestErrors.testError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}


extension MoviesLoaderTests {
    struct StubNetworkClient: NetworkRouting {
        
        enum TestErrors: Error, Equatable {
            case testError
        }
        
        let emulateError: Bool
        let testData =
"""
{
   "errorMessage" : "",
   "items" : [
      {
         "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
         "fullTitle" : "Prey (2022)",
         "id" : "tt11866324",
         "imDbRating" : "7.2",
         "imDbRatingCount" : "93332",
         "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
         "rank" : "1",
         "rankUpDown" : "+23",
         "title" : "Prey",
         "year" : "2022"
      },
      {
         "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
         "fullTitle" : "The Gray Man (2022)",
         "id" : "tt1649418",
         "imDbRating" : "6.5",
         "imDbRatingCount" : "132890",
         "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
         "rank" : "2",
         "rankUpDown" : "-1",
         "title" : "The Gray Man",
         "year" : "2022"
      }
    ]
  }
""".data(using: .utf8)!
        
        func fetch(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
            if emulateError {
                handler(.failure(TestErrors.testError))
            } else {
                handler(.success(testData))
            }
        }
    }
    
}
