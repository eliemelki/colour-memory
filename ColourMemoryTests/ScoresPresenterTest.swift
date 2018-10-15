//
//  ScoresPresenterTest.swift
//  ColourMemoryTests
//
//  Created by Elie Melki on 23/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import XCTest
@testable import ColourMemory

class ScoresPresenterTest: XCTestCase {
    
    class MockScoresView : ScoreView {
        var showScoresCalled = false
        func showScores(scores: [GameScore]) {
            self.showScoresCalled = true
        }
    }
    
    class MockScoreDataSource : ScoreDataSource {
        var highScoresCalled = false
        func scores() -> [GameScore] {
            return [GameScore(user: "user", score: 1)]
        }
        
        func save(score: GameScore) -> Bool {
            return false
        }
        
        func highScores() -> [GameScore] {
            highScoresCalled = true
            return scores()
        }
        
        func isHighScore(score: Int) -> Bool {
            return false
        }
        
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScoresPresenter() {
        let mockDataSource = MockScoreDataSource()
        let mockView = MockScoresView()
        let presenter = DefaultScorePresenter(dataSource: mockDataSource)
        
        XCTAssertNil(presenter.view)
        XCTAssertNotNil(presenter.dataSource)
        presenter.attach(view: mockView)
        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(mockDataSource.highScoresCalled)
        XCTAssertTrue(mockView.showScoresCalled)
        
    }
    
   
    
}
