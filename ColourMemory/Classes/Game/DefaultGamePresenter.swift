//
//  DefaultGamePresenter.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit
import Dispatch

extension Array where Element: Equatable  {
    mutating func remove(element: Array.Element) {
        if let elementIndex = self.index(of: element) {
            self.remove(at: elementIndex)
        }
    }
}

class DefaultGamePresenter: NSObject {
    private static let WINING_POINTS = 2
    private static let LOSING_POINTS = 1
    
    weak var view:GameView?
    
    let scoreDataSource : ScoreDataSource
    let gameDataSource : GameDataSource
    
    var cards:[Card]
    var score = 0
    var openedCardsIndexes = [Int]()
    var roundCardIndex:Int?
    
    init (gameDataSource: GameDataSource, scoreDataSource: ScoreDataSource) {
        self.scoreDataSource = scoreDataSource
        self.gameDataSource = gameDataSource
        self.cards = gameDataSource.generateCards()
    }
    
   
    
    fileprivate func processEndGame() {
        var message = "Congratulations"
        if (self.scoreDataSource.isHighScore(score: score)) {
            message = "Congratulations :D. New Score \(score)"
        }
        self.view?.showUserUI(with: message)
    }
 
    fileprivate func processWinRound() {
    
        self.score += DefaultGamePresenter.WINING_POINTS
        self.view?.blockView()
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            if let strongSelf = self {
                strongSelf.view?.showScore(value: strongSelf.score)
                strongSelf.view?.unblockView()
                
                
                if (strongSelf.openedCardsIndexes.count == strongSelf.cards.count) {
                    strongSelf.processEndGame()
                }
            }
        }
    }
    
    fileprivate func processLostRound(roundCard: Int,  at: Int) {
        //clear the round card
       
        self.score -= DefaultGamePresenter.LOSING_POINTS
        self.openedCardsIndexes.remove(element: roundCard)
        self.openedCardsIndexes.remove(element: at)
        self.view?.blockView()
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            if let strongSelf = self {
                strongSelf.view?.showScore(value: strongSelf.score)
                strongSelf.view?.closeCard(at: at)
                
                strongSelf.view?.closeCard(at: roundCard)
               
                strongSelf.view?.unblockView()
            }
        }
    }
    
    func resetGame() {
        self.score = 0
        self.openedCardsIndexes = []
        self.roundCardIndex = nil
        self.cards = self.gameDataSource.generateCards()
    }
    
}


extension DefaultGamePresenter : GamePresenter {
    
    
    func isCardOpened(at: Int) -> Bool {
        
        if openedCardsIndexes.contains(at) {
            return true
        }
        
        return false
        
    }
    
    func cardImage(at: Int) -> String {
        return self.cards[at].cardImage
    }
    
    func attach(view: GameView) {
        self.view = view
         self.view?.showScore(value: self.score)
    }
    
    
    func openCard(at: Int) {
        
        //check if index is within boundary
        guard at >= 0 && at < cards.count else {
            return
        }
        
        
        //check if we can open a card. Not Opened before
        guard !isCardOpened(at: at) else {
            return
        }
        
        //If the round just started set the round Initial Card
        guard let roundCardIndex = self.roundCardIndex else {
            self.roundCardIndex = at
            self.openedCardsIndexes.append(at)
            self.view?.openCard(at: at)
            return
        }
        
        self.openedCardsIndexes.append(at)
        self.view?.openCard(at: at)
        
        //If the initial round card is set check if the new selected match
        let roundCard = self.cards[roundCardIndex]
        let selectedCard = self.cards[at]
        if (selectedCard.hasEqualType(with: roundCard)) {
             //we have a matching round
            processWinRound()
        }else {
            //we have a none matching round
            processLostRound(roundCard: roundCardIndex, at: at)
        }
        
        self.roundCardIndex = nil
    }
    
    func cardsCount() -> Int {
        return self.cards.count
    }
    
    func saveUser(user: String) {
        let score = GameScore(user: user, score: self.score)
        if (self.scoreDataSource.save(score:score)) {
            self.resetGame()
            self.view?.reloadGame()
            self.view?.showScore(value: self.score)
        }
    }

    
}

extension Card {
    var cardImage: String {
        get {
            switch type {
            case .Color1:
                return "colour1"
            case .Color2:
                return "colour2"
            case .Color3:
                return "colour3"
            case .Color4:
                return "colour4"
            case .Color5:
                return "colour5"
            case .Color6:
                return "colour6"
            case .Color7:
                return "colour7"
            case .Color8:
                return "colour8"
            }
        }
    }
}
