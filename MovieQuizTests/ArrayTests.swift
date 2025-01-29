//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Vladimir on 08.01.2025.
//

import XCTest

@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGettingValueInRange() throws {
//        given
        let array = [1,1,2,3,4]
        let index = 2
//        when
        let result = array[safe: index]
//        then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 2)
    }
    
    func testGettingValueOutOfRange() throws {
//        given
        let array = [1,1,2,3,4]
        let indicies = [-1, array.count, 20]
        for index in indicies {
//            when
            let result = array[safe: index]
//            then
            XCTAssertNil(result)
        }
    }
}
