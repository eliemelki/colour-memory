//
//  UserPresenterTest.swift
//  ColourMemoryTests
//
//  Created by Elie Melki on 23/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import XCTest
@testable import ColourMemory



class UserPresenterTest: XCTestCase {
    class MockUserView : UserView {
        
        var showMessageCalled = false
        var showUsernameValidationCalled = false
        var clearUsernameValidationErrorCalled = false
        var doneCalled = false
        
        func showMessage(_ message: String) {
            self.showMessageCalled = true
        }
        
        func showUsernameValidation(error: String) {
            self.showUsernameValidationCalled = true
        }
        
        func clearUsernameValidationError() {
            self.clearUsernameValidationErrorCalled = true
        }
        
        func done(user: String) {
            self.doneCalled = true
        }
        
        func reset() {
            self.showMessageCalled = false
            self.showUsernameValidationCalled = false
            self.clearUsernameValidationErrorCalled = false
            self.doneCalled = false
        }
        
        var delegate: UserViewDelegate?
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUserPresenter() {
        let presenter = DefaultUserPresenter()
        let mockView = MockUserView()
        
        XCTAssertNil(presenter.view)
        presenter.attach(view: mockView)
        XCTAssertNotNil(presenter.view)
        
        presenter.save(user: nil)
        XCTAssertTrue(mockView.showUsernameValidationCalled)
        
        mockView.reset()
        presenter.save(user: "user")
        XCTAssertTrue(mockView.clearUsernameValidationErrorCalled)
        XCTAssertTrue(mockView.doneCalled)
        
        mockView.reset()
        presenter.save(user: "")
        XCTAssertTrue(mockView.showUsernameValidationCalled)

    }
    
    
}
