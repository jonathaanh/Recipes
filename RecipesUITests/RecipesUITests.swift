//
//  RecipesUITests.swift
//  RecipesUITests
//
//  Created by Jonathan Hsu on 3/15/24.
//

import XCTest

final class RecipesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testMealNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        // Assert the "Desserts" title is present
        XCTAssertTrue(app.navigationBars["Desserts"].exists, "The title 'Desserts' is not present in the navigation bar.")

        // Wait for the meals to load. Adjust the timeout as necessary.
        let firstMealCell = app.cells.firstMatch
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: firstMealCell)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 10.0)
        switch result {
            case .completed:
                firstMealCell.tap()
                
                // Verify navigation has occurred by checking for a specific UI element in `MealDetailView`.
                // This could be the "Instructions" text or any unique element that confirms the view has changed.
                let instructionsTextExists = app.staticTexts["Instructions"].waitForExistence(timeout: 5)
                XCTAssertTrue(instructionsTextExists, "Instructions text does not exist or was not found after navigating to MealDetailView.")
                
            default:
                XCTFail("The first meal cell did not appear in time.")
        }
    }
}
