//
//  SwapiUITests.swift
//  SwapiUITests
//
//  Created by TuyenLe on 7/29/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import XCTest

class SwapiUITests: XCTestCase {

    var app: XCUIApplication = XCUIApplication()

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableView(identifier: String) {
        let table = app.tables.matching(identifier: identifier).element(boundBy: 0)

        for index in 0..<table.cells.count {
            let cell = table.cells.element(boundBy: index)
            table.scrollToElement(element: cell)
            table.cells.matching(.staticText, identifier: cell.value as? String)
        }
    }

    func onTapMenuBar(index: Int) {
        let categoryTable = app.tables.matching(identifier: "CategoriesTableView").element(boundBy: 0)
        categoryTable.cells.element(boundBy: index).tap()
    }

    func testEntitiesTableView() {
        let table = app.tables.matching(identifier: "CharactersTableView").element(boundBy: 0)
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)

        // characters
        testTableView(identifier: "CharactersTableView")

        // films
        let charactersMenuBar = app.buttons.matching(identifier: "CharactersMenuBar").element(boundBy: 0)
        charactersMenuBar.tap()

        onTapMenuBar(index: 1)
        testTableView(identifier: "FilmsTableView")

        // planets
        let filmsMenuBar = app.buttons.matching(identifier: "FilmsMenuBar").element(boundBy: 0)
        filmsMenuBar.tap()

        onTapMenuBar(index: 2)
        testTableView(identifier: "PlanetsTableView")

        // species
        let planetsMenuBar = app.buttons.matching(identifier: "PlanetsMenuBar").element(boundBy: 0)
        planetsMenuBar.tap()

        onTapMenuBar(index: 3)
        testTableView(identifier: "SpeciesTableView")

        // starships
        let speciesMenuBar = app.buttons.matching(identifier: "SpeciesMenuBar").element(boundBy: 0)
        speciesMenuBar.tap()

        onTapMenuBar(index: 4)
        testTableView(identifier: "StarshipsTableView")

        // vehicles
        let starshipsMenuBar = app.buttons.matching(identifier: "StarshipsMenuBar").element(boundBy: 0)
        starshipsMenuBar.tap()

        onTapMenuBar(index: 5)
        testTableView(identifier: "VehiclesTableView")

    }
    
    func testDetailsView() {
        

        let table = app.tables.matching(identifier: "CharactersTableView").element(boundBy: 0)
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)

        table.cells.element(boundBy: 0).tap()
        app.buttons.element(matching: .button, identifier: "charactersRightScrollViewButton").tap(withNumberOfTaps: 10, numberOfTouches: 5)

        app.buttons.element(matching: .button, identifier: "charactersLeftScrollViewButton").tap(withNumberOfTaps: 10, numberOfTouches: 5)

        app.navigationBars.buttons.element(boundBy: 0).tap()

        table.cells.element(boundBy: 1).tap()
        app.scrollViews.element(matching: .scrollView, identifier: "characterDetailScrollView").swipeLeft()
        app.scrollViews.element(matching: .scrollView, identifier: "characterDetailScrollView").swipeRight()

        app.navigationBars.buttons.element(boundBy: 0).tap()
        
    }
}


extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.isVisible {
            swipeUp()
        }
    }

    var isVisible: Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
