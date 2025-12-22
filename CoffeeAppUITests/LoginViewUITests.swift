//
//  LoginViewUITests.swift
//  CoffeeAppUITests
//
//  Created by Ameya on 21/12/25.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    var app: XCUIApplication!
    var usernameTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        
        usernameTextField = app.textFields["UsernameTextField"]
        passwordTextField = app.secureTextFields["PasswordTextField"]
        loginButton = app.buttons["LoginButton"]
    }

    override func tearDownWithError() throws {
        app = nil
        usernameTextField = nil
        passwordTextField = nil
        loginButton = nil
        
        try super.tearDownWithError()
    }

    func testLoginView_WhenScreenIsLaunched_UsernameAndPasswordAreEnabled() throws {
        XCTAssertTrue(usernameTextField.isEnabled, "LoginView's username textfield should have been enabled on launch")
        XCTAssertTrue(passwordTextField.isEnabled, "LoginView's password textfield should have been enabled on launch")
    }
    
    func testLoginView_WhenScreenIsLaunched_LoginButtonIsDisabled() throws {
        XCTAssertFalse(loginButton.isEnabled, "LoginView's loginButton should have been disabled on launch")
    }
    
    func testLoginView_WhenUserEntersShortUsername_LoginButtonRemainsDisabled() {
        usernameTextField.tap()
        usernameTextField.typeText("joh")
        
        XCTAssertFalse(loginButton.isEnabled, "LoginView's loginButton should have been disabled on incomplete username")
    }
    
    func testLoginView_WhenUserEntersShortPassword_LoginButtonRemainsDisabled() {
        passwordTextField.tap()
        passwordTextField.typeText("1234567")

        XCTAssertFalse(loginButton.isEnabled, "LoginView's loginButton should have been disabled on incomplete password")
    }
    
    func testLoginView_WhenUserEntersValidDetails_LoginButtonIsEnabled() {
        usernameTextField.tap()
        usernameTextField.typeText("john")
        
        passwordTextField.tap()
        passwordTextField.typeText("12345678")
        
        XCTAssertTrue(loginButton.isEnabled, "LoginView's loginButton should have been enabled on valid username")
    }
    
    func testLoginView_WhenUserEntersWrongDetails_AlertErrorIsShown() {
        usernameTextField.tap()
        usernameTextField.typeText("john")
        
        passwordTextField.tap()
        passwordTextField.typeText("12345678")
        
        loginButton.tap()
        
        let alert = app.staticTexts["Invalid Credentials"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2), "When user enters wrong credentials, an alert should be shown")
    }
    
    func testLoginView_WhenUserEntersRightDetails_UserIsLoggedIn() {
        usernameTextField.tap()
        usernameTextField.typeText("hello.demo")
        
        passwordTextField.tap()
        passwordTextField.typeText("12345678")
        
        loginButton.tap()
        
        let usernameAttachment = XCTAttachment(screenshot: usernameTextField.screenshot())
        usernameAttachment.name = "usernameTextFieldScreenshot"
        usernameAttachment.lifetime = .keepAlways
        add(usernameAttachment)
        
        let appAttachment = XCTAttachment(screenshot: app.screenshot())
        appAttachment.name = "appScreenshot"
        appAttachment.lifetime = .keepAlways
        add(appAttachment)
        
        let orderListScreen = app.navigationBars["Orders"]
        XCTAssertTrue(orderListScreen.waitForExistence(timeout: 2), "When user enters right credentials, they should be redirected to the Orders screen")
    }
}
