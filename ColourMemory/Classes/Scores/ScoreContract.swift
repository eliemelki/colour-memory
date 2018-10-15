//
//  ScoreContract.swift
//  ColourMemory
//
//  Created by Elie Melki on 20/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import Foundation

protocol ScoreView : class {
    func showScores(scores : [GameScore])
}

protocol ScorePresenter : class {
    func attach(view: ScoreView)
}
