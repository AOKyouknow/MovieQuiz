//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Алик on 06.07.2026.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        //When. Функция загрузки ассинхронная - требуется ожидание.
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            
            //Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 1)
    }
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        
        //When
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            
            
            //Then
            switch result {
            case .success:
                XCTFail("Download movies")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
    
}
