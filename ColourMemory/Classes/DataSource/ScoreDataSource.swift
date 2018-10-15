//
//  ScoreDataSource.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import Foundation
import UIKit

protocol ScoreDataSource : class {
    func scores() ->  [GameScore]
    func save(score: GameScore) -> Bool
    func highScores() -> [GameScore]
    func isHighScore(score: Int) -> Bool
}

class GameScore : NSObject, NSCoding {
    
    let username:String
    let score:Int
    

    init(user: String, score: Int) {
        self.username = user
        self.score = score
    }
    required init(coder decoder: NSCoder) {
        self.username = decoder.decodeObject(forKey: "username") as? String ?? ""
        self.score = decoder.decodeInteger(forKey: "score")
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(score, forKey: "score")
    }
    
}


class DefaultScoreDataSource : ScoreDataSource {
    func isHighScore(score: Int) -> Bool {
        let scores = self.highScores()
        if (scores.count > 0) {
            return scores[0].score < score
        }
        return true
    }
    
    
    fileprivate static let SCORE_KEY = "SCORE_KEY"
    
    func scores() -> [GameScore] {
        if let data = UserDefaults.standard.data(forKey: DefaultScoreDataSource.SCORE_KEY) {
            if let scores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [GameScore] {
                return scores
            }
        }
        
        return []
    }
    
    func highScores() -> [GameScore] {
        var scores =  self.scores()
        scores.sort { (score1, score2) -> Bool in
            return score1.score > score2.score
        }
        
        return Array(scores.prefix(5))
    }
    
    func save(score: GameScore) -> Bool {
        var scores = self.scores()
        scores.append(score)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: scores)
        UserDefaults.standard.removeObject(forKey: DefaultScoreDataSource.SCORE_KEY)
        UserDefaults.standard.set(encodedData, forKey:  DefaultScoreDataSource.SCORE_KEY)
        return true
    }
}
