//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Алик on 04.07.2026.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2:Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func subsctraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
       
}





final class MovieQuizTests: XCTestCase {
    
    func testAddition() throws {
        //Given
        let arithmeticsOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        let expectation = expectation(description: "Addition function expectation")// NEW!!!
        
        arithmeticsOperations.addition(num1: num1, num2: num2) {
            result in
            
            
            //Then
            XCTAssertEqual(result, 3) // сравниваем результат выполнения функции и наши ожидания
            //XCTAssertEqual, которая сравнивает два значения и маркирует тест как пройденный или как непройденный
            expectation.fulfill() // NEW!!!
        }
        waitForExpectations(timeout: 2) // NEW!!!
    }
}
