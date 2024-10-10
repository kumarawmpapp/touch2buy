//
//  Touch2BuyUITests.swift
//  Touch2BuyUITests
//
//  Created by Pradeep Kumara on 4/7/16.
//  Copyright © 2016 TouchBuy. All rights reserved.
//

import XCTest

class Touch2BuyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testOrderList()  {
        
        
        
    }
    
    func testProductList() {
        
        
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        
        
        
        
    }
    
    func testCartScreen() {
        
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        
        let window = app.childrenMatchingType(.Window).elementBoundByIndex(0)
        window.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        app.buttons["cart"].tap()
        
        let element = window.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element
        element.swipeUp()
        element.swipeUp()
        
        let tablesQuery2 = app.tables
        let minimumTimeToPrepareAnOrderIs29minTimeToDeliverWillBeDecidedBasedOnYourRecievingLocationStaticText = tablesQuery2.staticTexts["Minimum time to prepare an order is 29min. Time to deliver will be decided based on your recieving location."]
        minimumTimeToPrepareAnOrderIs29minTimeToDeliverWillBeDecidedBasedOnYourRecievingLocationStaticText.tap()
        
        let tablesQuery = tablesQuery2
        tablesQuery.staticTexts["Kolpity"].tap()
        element.tap()
        tablesQuery.staticTexts["Dialog EzCash"].tap()
        tablesQuery.buttons["Home Delivery"].tap()
        
        let newAddressButton = tablesQuery.buttons["New Address"]
        newAddressButton.tap()
        newAddressButton.tap()
        
        let selectAddressButton = tablesQuery.buttons["Select Address"]
        selectAddressButton.swipeUp()
        minimumTimeToPrepareAnOrderIs29minTimeToDeliverWillBeDecidedBasedOnYourRecievingLocationStaticText.tap()
        selectAddressButton.tap()
        element.tap()
        window.childrenMatchingType(.Other).elementBoundByIndex(2).tables.childrenMatchingType(.Cell).elementBoundByIndex(3).staticTexts["sadf,sdfdsf,Borella,Sri Lanka,0722935442"].tap()
        tablesQuery.staticTexts["sadf sdfdsf Borella Sri Lanka 0722935442"].tap()
        newAddressButton.tap()
        
        let textField = app.tables.containingType(.Other, identifier:"DELIVERY DETAILS").childrenMatchingType(.Cell).elementBoundByIndex(3).childrenMatchingType(.TextField).elementBoundByIndex(1)
        textField.tap()
        newAddressButton.tap()
        textField.tap()
        tablesQuery.staticTexts["Galle"].tap()
        
    }
    
}
