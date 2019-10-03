//
//  Hand.swift
//  Blackjack
//
//  Created by Will Said on 10/1/19.
//  Copyright © 2019 Will Said. All rights reserved.
//

import Foundation

struct Hand {
    
    var type: Player
    var cards: [Card] // initially 2, but hitting can increase
    var standing = false
    
    var sum: Int {
        // TODO: - WHAT IF THEY HAVE MULTIPLE ACES?
        // the softSum would reduce every ace to equal 1;
        // however, what if there were 2 ace's, for a total of 1 + 11 = 12?
        // Well, it doesn't matter since 12 has a lower expectation than 2 soft aces.
        // See the Hint class for more info.
        let softValue = cards.reduce(0, { $0 + $1.softValue })
        let hardValue = cards.reduce(0, { $0 + $1.hardValue })
        if hardValue <= 21 {
            return hardValue
        }
        return softValue
    }
    
    var isBlackjack: Bool {
        sum == 21
    }
    
    init(type: Player) {
        self.type = type
        
        // each player starts with 2 cards
        self.cards = [Card(), Card()]
    }
    
    init(type: Player, cards: [Card]) {
        self.type = type
        self.cards = cards
    }
    
    mutating func hit() {
        self.cards.append(Card())
    }
    
    mutating func stand() {
        self.standing = true
    }
    
    func getHint(dealerHand: Hand) {
        let bestMove = Hint(dealerHand: dealerHand, playerHand: self).bestMove()
        print("The ideal move is to \(bestMove)")
    }
}
