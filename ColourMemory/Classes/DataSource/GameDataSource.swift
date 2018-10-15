//
//  DefaultGameDataSource.swift
//  ColourMemory
//
//  Created by Elie Melki on 19/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit

enum CardType {
    case Color1
    case Color2
    case Color3
    case Color4
    case Color5
    case Color6
    case Color7
    case Color8
}

class Card : NSObject {
    let type:CardType
    
    
    init(type:CardType) {
        self.type = type
    }
    
    func hasEqualType(with: Card) -> Bool{
        return self.type == with.type
    }
}

protocol GameDataSource : class {
    func generateCards() -> [Card]
}

class DefaultGameDataSource: NSObject {
    static let DEFAULT_CARD_SET = [Card(type:CardType.Color1), Card(type:CardType.Color1),
                                   Card(type:CardType.Color2), Card(type:CardType.Color2),
                                   Card(type:CardType.Color3), Card(type:CardType.Color3),
                                   Card(type:CardType.Color4), Card(type:CardType.Color4),
                                   Card(type:CardType.Color5), Card(type:CardType.Color5),
                                   Card(type:CardType.Color6), Card(type:CardType.Color6),
                                   Card(type:CardType.Color7), Card(type:CardType.Color7),
                                   Card(type:CardType.Color8), Card(type:CardType.Color8)];
    
    
}

extension DefaultGameDataSource : GameDataSource {
    func generateCards() -> [Card] {
        var readingCards = DefaultGameDataSource.DEFAULT_CARD_SET
        let count = readingCards.count
        var shufledCards:[Card?] = Array(repeating: nil, count: count)
        
        for i in (0..<count).reversed() {
            let randomInt = Int(arc4random_uniform(UInt32(i+1)))
            let card = readingCards[randomInt]
            shufledCards[i] = card
            readingCards.remove(at: randomInt)
        }
        
        return shufledCards as! [Card]
    }
    
    
}

