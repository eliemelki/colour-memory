//
//  GameContract.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import Foundation



protocol GamePresenter : class {
    func attach(view: GameView)
    func isCardOpened(at: Int) -> Bool
    func cardImage(at: Int) -> String
    func openCard(at :Int)
    func cardsCount() -> Int
    func saveUser(user: String)
}

protocol GameView : class {
    func openCard(at: Int)
    func closeCard(at: Int)
    func showScore(value: Int)
    func blockView()
    func unblockView()
     func showUserUI(with message: String) 
    func reloadGame()
}



