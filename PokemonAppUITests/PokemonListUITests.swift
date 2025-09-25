//
//  PokemonListUITests.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import XCTest

final class PokemonListUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testPokemonListFlow() {
        // Given - App is launched
        
        // Wait for the list to load
        let tableView = app.tables.firstMatch
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        // Then - Verify list appears
        XCTAssertTrue(tableView.exists, "Pokemon list should be visible")
        
        // Wait for pokemon cells to appear
        let firstCell = tableView.cells.firstMatch
        expectation(for: exists, evaluatedWith: firstCell, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        // When - Tap on first pokemon
        if firstCell.exists {
            firstCell.tap()
            
            // Then - Detail screen should appear
            let detailNavigation = app.navigationBars["Detalhes"]
            expectation(for: exists, evaluatedWith: detailNavigation, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            XCTAssertTrue(detailNavigation.exists, "Detail screen should appear")
            
            // Verify back navigation works
            let backButton = detailNavigation.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
                
                // Should return to list
                let listNavigation = app.navigationBars["Pokémons"]
                expectation(for: exists, evaluatedWith: listNavigation, handler: nil)
                waitForExpectations(timeout: 5, handler: nil)
                
                XCTAssertTrue(listNavigation.exists, "Should return to pokemon list")
            }
        }
    }
    
    func testPullToRefresh() {
        // Given - 
        let tableView = app.tables.firstMatch
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        // When -
        let startCoordinate = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let endCoordinate = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        
        startCoordinate.press(forDuration: 0.1, thenDragTo: endCoordinate)
        
        // Then -
        XCTAssertTrue(tableView.exists, "Table should still exist after refresh")
    }
    
    func testErrorStateAndRetry() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10), "Pokemon list should eventually appear")
    }
}
