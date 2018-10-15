//
//  GamePresenterTest.swift
//  ColourMemoryTests
//
//  Created by Elie Melki on 23/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import XCTest
import Dispatch
@testable import ColourMemory

class GamePresenterTest: XCTestCase {
    
    static let DEFAULT_CARD_SET = [Card(type:CardType.Color1), Card(type:CardType.Color1),
                                   Card(type:CardType.Color2), Card(type:CardType.Color2),
                                   Card(type:CardType.Color3), Card(type:CardType.Color3)]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGamePresenterInitialisation() {
        
        let holder = MockHolder()
       
        //Test initial
        XCTAssertNotNil(holder.presenter.gameDataSource)
        XCTAssertNotNil(holder.presenter.scoreDataSource)
        XCTAssertEqual(holder.presenter.cards, GamePresenterTest.DEFAULT_CARD_SET)
        XCTAssertEqual(holder.presenter.score, 0)
        XCTAssertEqual(holder.presenter.openedCardsIndexes, [])
        XCTAssertNil(holder.presenter.roundCardIndex)
        XCTAssertNil(holder.presenter.view)
    }
    
    func testViewAttach() {
         let holder = MockHolder()
        //Test view attach
        holder.presenter.attach(view: holder.mockView)
        XCTAssertNotNil(holder.presenter.view)
        XCTAssertTrue(holder.mockView.showScoreCalled)
        XCTAssertEqual(holder.presenter.score, holder.mockView.showScoreIntValue)
    }
    
    func testOpenOutOfBounds() {
        
        let holder = MockHolder()
        holder.presenter.attach(view: holder.mockView)
        holder.mockView.reset()
        //Test Open first card
        var index = -1
        holder.presenter.openCard(at: index)
        XCTAssertFalse(holder.mockView.openCardCalled)
        XCTAssertFalse(holder.mockView.closeCardCalled)
        XCTAssertEqual(holder.mockView.openCardIndex, -1)
        XCTAssertEqual(holder.presenter.openedCardsIndexes, [])
        XCTAssertNil(holder.presenter.roundCardIndex)
        XCTAssertFalse(holder.mockView.showScoreCalled)
        XCTAssertEqual(holder.presenter.score, 0)
    
        index = holder.presenter.cards.count
        holder.mockView.reset()
        holder.presenter.openCard(at: index)
        XCTAssertFalse(holder.mockView.openCardCalled)
        XCTAssertFalse(holder.mockView.closeCardCalled)
        XCTAssertEqual(holder.mockView.openCardIndex, -1)
        XCTAssertEqual(holder.presenter.openedCardsIndexes, [])
        XCTAssertNil(holder.presenter.roundCardIndex)
        XCTAssertFalse(holder.mockView.showScoreCalled)
        XCTAssertEqual(holder.presenter.score, 0)
        
    }
    
    func testGameFalseRound() {
        
        let holder = MockHolder()
        holder.presenter.attach(view: holder.mockView)
        holder.mockView.reset()
        //Test Open first card
        var index = 2
        holder.presenter.openCard(at: index)
        XCTAssertTrue(holder.mockView.openCardCalled)
        XCTAssertFalse(holder.mockView.closeCardCalled)
        XCTAssertEqual(holder.mockView.openCardIndex, index)
        XCTAssertEqual(holder.presenter.openedCardsIndexes, [index])
        XCTAssertEqual(holder.presenter.roundCardIndex!, index)
        XCTAssertFalse(holder.mockView.showScoreCalled)
        XCTAssertEqual(holder.presenter.score, 0)
        
        //test open same card
        holder.mockView.openCardCalled = false
        holder.presenter.openCard(at: index)
        XCTAssertFalse(holder.mockView.openCardCalled)
        XCTAssertFalse(holder.mockView.closeCardCalled)
        XCTAssertEqual(holder.mockView.openCardIndex, 2)
        XCTAssertEqual(holder.presenter.openedCardsIndexes, [index])
        XCTAssertEqual(holder.presenter.roundCardIndex!, index)
        XCTAssertEqual(holder.presenter.score, 0)
        
        
        //Test false round
        let expectation = XCTestExpectation( description: "wait")
        
        index = 1
        holder.mockView.reset()
        holder.presenter.openCard(at: index)
        XCTAssertTrue(holder.mockView.blockViewCalled)
        let deadline = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertTrue(holder.mockView.openCardCalled)
            XCTAssertEqual(holder.mockView.openCardIndex, 1)
            
            XCTAssertTrue(holder.mockView.closeCardCalled)
            XCTAssertTrue(holder.mockView.unlockViewCalled)
           
            XCTAssertEqual(holder.mockView.closeCardIndex, 2)
            XCTAssertEqual(holder.presenter.openedCardsIndexes, [])
            XCTAssertNil(holder.presenter.roundCardIndex)
            XCTAssertEqual(holder.presenter.score, -1)
            XCTAssertTrue(holder.mockView.showScoreCalled)
            XCTAssertEqual(holder.mockView.showScoreIntValue, -1)
            
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testGameSuccessRound() {
        
        let holder = MockHolder()
        holder.presenter.attach(view: holder.mockView)
        holder.mockView.reset()
        var index = 2
        holder.presenter.openCard(at: index)
      
        let expectation = XCTestExpectation( description: "wait")
        
        index = 3
        holder.mockView.reset()
        holder.presenter.openCard(at: index)
        XCTAssertTrue(holder.mockView.blockViewCalled)
        let deadline = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertTrue(holder.mockView.openCardCalled)
            XCTAssertEqual(holder.mockView.openCardIndex, 3)
            
            XCTAssertFalse(holder.mockView.closeCardCalled)
            XCTAssertTrue(holder.mockView.unlockViewCalled)
            
            XCTAssertEqual(holder.mockView.closeCardIndex, -1)
            XCTAssertEqual(holder.presenter.openedCardsIndexes, [2,3])
            XCTAssertNil(holder.presenter.roundCardIndex)
            XCTAssertEqual(holder.presenter.score, 2)
            XCTAssertTrue(holder.mockView.showScoreCalled)
            XCTAssertEqual(holder.mockView.showScoreIntValue, 2)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGameConsecutiveSuccessRound() {
        
        let holder = MockHolder()
        holder.presenter.attach(view: holder.mockView)
        holder.mockView.reset()
        var index = 2
        holder.presenter.openCard(at: index)
        index = 3
        holder.presenter.openCard(at: index)
        
        index = 0
        holder.presenter.openCard(at: index)
        index = 1
        holder.mockView.reset()
        holder.presenter.openCard(at: index)
        
        let expectation = XCTestExpectation( description: "wait")
        
        
        XCTAssertTrue(holder.mockView.blockViewCalled)
        let deadline = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertTrue(holder.mockView.openCardCalled)
            XCTAssertEqual(holder.mockView.openCardIndex, 1)
            
            XCTAssertFalse(holder.mockView.closeCardCalled)
            XCTAssertTrue(holder.mockView.unlockViewCalled)
            
            XCTAssertEqual(holder.mockView.closeCardIndex, -1)
            XCTAssertEqual(holder.presenter.openedCardsIndexes, [2,3,0,1])
            XCTAssertNil(holder.presenter.roundCardIndex)
            XCTAssertEqual(holder.presenter.score, 4)
            XCTAssertTrue(holder.mockView.showScoreCalled)
            XCTAssertEqual(holder.mockView.showScoreIntValue, 4)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGameConsecutiveFailRound() {
        
        let holder = MockHolder()
        holder.presenter.attach(view: holder.mockView)
        holder.mockView.reset()
        var index = 2
        holder.presenter.openCard(at: index)
        index = 3
        holder.presenter.openCard(at: index)
        
        index = 0
        holder.presenter.openCard(at: index)
        index = 5
        holder.mockView.reset()
        holder.presenter.openCard(at: index)
        
        let expectation = XCTestExpectation( description: "wait")
        
        
        XCTAssertTrue(holder.mockView.blockViewCalled)
        let deadline = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertTrue(holder.mockView.openCardCalled)
            XCTAssertEqual(holder.mockView.openCardIndex, 5)
            
            XCTAssertTrue(holder.mockView.closeCardCalled)
            XCTAssertTrue(holder.mockView.unlockViewCalled)
            
            XCTAssertEqual(holder.mockView.closeCardIndex, 0)
            XCTAssertEqual(holder.presenter.openedCardsIndexes, [2,3])
            XCTAssertNil(holder.presenter.roundCardIndex)
            XCTAssertEqual(holder.presenter.score, 1)
            XCTAssertTrue(holder.mockView.showScoreCalled)
            XCTAssertEqual(holder.mockView.showScoreIntValue, 1)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
     func testEndGameRound() {
        let holder = MockHolder()
        holder.presenter.attach(view: holder.mockView)
        
        var index = 2
        holder.presenter.openCard(at: index)
        index = 3
        holder.presenter.openCard(at: index)
        
        index = 0
        holder.presenter.openCard(at: index)
        index = 5
        holder.presenter.openCard(at: index)
        
        index = 4
        holder.presenter.openCard(at: index)
        index = 5
        holder.presenter.openCard(at: index)
        
        index = 0
        holder.presenter.openCard(at: index)
        index = 1
        holder.mockView.reset()
        holder.presenter.openCard(at: index)
        
        let deadline = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            XCTAssertEqual(holder.presenter.score, 5)
            XCTAssertTrue(holder.mockView.showScoreCalled)
            XCTAssertEqual(holder.mockView.showScoreIntValue, 5)
            
            XCTAssertTrue(holder.mockView.showUserUICalled)
            holder.presenter.saveUser(user: "User")
            XCTAssertTrue(holder.mockScoreDataSource.isHighScoreCalled)
            XCTAssertEqual(holder.mockScoreDataSource.isHighScoreCalled, true)
            
            XCTAssertTrue(holder.mockScoreDataSource.saveScoreCalled)
            XCTAssertTrue(holder.mockView.reloadGameCalled)
            
            XCTAssertEqual(holder.presenter.cards, GamePresenterTest.DEFAULT_CARD_SET)
            XCTAssertEqual(holder.presenter.score, 0)
            XCTAssertEqual(holder.presenter.openedCardsIndexes, [])
            XCTAssertNil(holder.presenter.roundCardIndex)
            
        }
    }
    

    
    class MockHolder {
        let presenter: DefaultGamePresenter
        let mockGameDataSource = MockGameDataSource()
        let mockScoreDataSource = MockScoreDataSource()
        let mockView = MockGameView()
        
        init() {
            self.presenter = DefaultGamePresenter(gameDataSource: mockGameDataSource, scoreDataSource: mockScoreDataSource)
        }
    }
    
    class MockGameView : GameView {
        var openCardCalled = false
        var openCardIndex = -1
        func openCard(at: Int) {
            self.openCardIndex = at
            self.openCardCalled = true
        }
        
        var closeCardCalled = false
        var closeCardIndex = -1
        func closeCard(at: Int) {
            self.closeCardIndex = at
            self.closeCardCalled = true
            
        }
        
        var showScoreCalled = false
        var showScoreIntValue = -1
        func showScore(value: Int) {
            self.showScoreIntValue = value
            self.showScoreCalled = true
        }
        
        var blockViewCalled = false
        func blockView() {
            self.blockViewCalled = true
        }
        
        var unlockViewCalled = false
        func unblockView() {
            self.unlockViewCalled = true
        }
        
        var showUserUICalled = false
        var userUIMessage = ""
        func showUserUI(with message: String) {
            self.showUserUICalled = true
            self.userUIMessage = message
        }
        
        
        var reloadGameCalled = false
        func reloadGame() {
            self.reloadGameCalled = true
        }
        
        func reset() {
            self.openCardCalled = false
            self.openCardIndex = -1
            
            self.closeCardCalled = false
            self.closeCardIndex = -1
            
            self.showScoreCalled = false
            self.showScoreIntValue = -1
            
            self.blockViewCalled = false
            self.unlockViewCalled = false
            
            self.showUserUICalled = false
            self.userUIMessage = ""
            
            self.reloadGameCalled = false
        }
    }
    
    class MockGameDataSource : GameDataSource {
        var generateCardsCalled = false
        func generateCards() -> [Card] {
            self.generateCardsCalled = true
            return GamePresenterTest.DEFAULT_CARD_SET
        }
        
     
        
        func reset() {
            self.generateCardsCalled = false
        }
    }
    
    class MockScoreDataSource : DefaultScoreDataSource {
        var scoreValue =  [GameScore]()
        
        var scoresCalled = false
        override func scores() -> [GameScore] {
            self.scoresCalled = true
            return scoreValue
        }
        
        var saveScoreCalled = false
        override func save(score: GameScore) -> Bool {
            self.saveScoreCalled = true
            self.scoreValue.append(score)
            return true
        }
        
        var highScoresCalled = false
        override func highScores() -> [GameScore] {
            self.highScoresCalled = true
            return super.highScores()
        }
        
        var isHighScoreCalled = false
        override func isHighScore(score: Int) -> Bool {
            self.isHighScoreCalled = true
            return super.isHighScore(score: score)
        }
        
        func reset() {
            self.scoresCalled = false
            self.saveScoreCalled = false
            self.highScoresCalled = false
            self.isHighScoreCalled = false
            
        }
        
    }
}

