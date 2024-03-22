//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Jonathan Hsu on 3/15/24.
//

import XCTest
@testable import Recipes

final class RecipesTests: XCTestCase {
    
    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = NetworkManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManager = nil
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // Implement similar tests for different scenarios...
    
    func testFetchMealsSuccess() throws {
        // Mock URLSession to return a predefined JSON response that represents a successful meal list fetch.
        // Configure the NetworkManager to use this mocked session.
        // Expectation to wait for the async operation to complete.
        let expectation = XCTestExpectation(description: "Fetch meals succeeds and returns a meal list.")
        
        // Call fetchMeals and verify the result is not nil and contains expected data.
        networkManager.fetchMeals { mealList in
            XCTAssertNotNil(mealList)
            // Additional assertions can check for specific meals in the list, counts, or other properties.
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMealDetailSuccess() throws {
        let expectation = XCTestExpectation(description: "Fetch meal detail succeeds and returns a meal detail.")
        
        networkManager.fetchMealDetail(id: "52772") { mealDetail in
            XCTAssertNotNil(mealDetail)
            // Assertions to check specific details of the meal, like its name, ingredients, etc.
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMealDetailFailure() throws {
        let expectation = XCTestExpectation(description: "Fetch meal detail fails and handles error gracefully.")
        
        networkManager.fetchMealDetail(id: "invalidID") { mealDetail in
            XCTAssertNil(mealDetail)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testMealDetailDecoding() throws {
            // Mock JSON string
            let jsonString = """
            {
                "idMeal": "52772",
                "strMeal": "Apple Frangipan Tart",
                "strMealThumb": "https://www.example.com/image.jpg",
                "strInstructions": "Preheat the oven...",
                "strIngredient1": "Apples",
                "strMeasure1": "1kg",
                "strIngredient2": "Sugar",
                "strMeasure2": "100g",
                "strIngredient3": "",
                "strMeasure3": ""
            }
            """
            
            // Convert jsonString to Data
            guard let jsonData = jsonString.data(using: .utf8) else {
                XCTFail("Failed to convert jsonString to Data")
                return
            }
            
            // Decode JSON to MealDetail
            let decoder = JSONDecoder()
            let mealDetail = try decoder.decode(MealDetail.self, from: jsonData)
            
            // Validate static properties
            XCTAssertEqual(mealDetail.idMeal, "52772")
            XCTAssertEqual(mealDetail.strMeal, "Apple Frangipan Tart")
            XCTAssertEqual(mealDetail.strMealThumb, "https://www.example.com/image.jpg")
            XCTAssertEqual(mealDetail.strInstructions, "Preheat the oven...")
            
            // Validate dynamic ingredients decoding
            XCTAssertEqual(mealDetail.ingredients.count, 2)
            XCTAssertEqual(mealDetail.ingredients[0].name, "Apples")
            XCTAssertEqual(mealDetail.ingredients[0].measurement, "1kg")
            XCTAssertEqual(mealDetail.ingredients[1].name, "Sugar")
            XCTAssertEqual(mealDetail.ingredients[1].measurement, "100g")
        }

}

