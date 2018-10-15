//
//  ScorePresenter.swift
//  ColourMemory
//
//  Created by Elie Melki on 20/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

class DefaultScorePresenter: NSObject, ScorePresenter {
    let dataSource : ScoreDataSource
    weak var view : ScoreView?
    
    init(dataSource : ScoreDataSource) {
        self.dataSource = dataSource
    }
    
    func attach(view: ScoreView) {
        self.view = view
        self.view?.showScores(scores: self.dataSource.highScores())
    }
}
