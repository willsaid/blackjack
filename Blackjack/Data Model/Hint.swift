//
//  Hint.swift
//  Blackjack
//
//  Created by Will Said on 10/1/19.
//  Copyright © 2019 Will Said. All rights reserved.
//

import Foundation

/*
 Wizard of Odds is where i got most of this information.
 You can also check out https://en.wikipedia.org/wiki/Blackjack
 */
struct Hint {
    
    let dealerHand: Hand
    let playerHand: Hand
    
    init(dealerHand: Hand, playerHand: Hand) {
        self.dealerHand = dealerHand
        self.playerHand = playerHand
    }
    
    /// Uses a prob dist table that maximizes expectation
    func bestMove() -> Move {
        
        let playerSum = playerHand.sum
        let dealerSum = dealerHand.sum
        
        if playerHand.cards.contains(where: { $0.isAce }) {
            // soft hand

            let aceCount = playerHand.cards.filter { $0.isAce }.count
            // let each ace count as 1, not 11
            let softSum = Hand(type: .player, cards: playerHand.cards.filter { $0.isAce == false }).sum + aceCount
            if softSum >= 8 {
                return .stand
            }
            if softSum == 7 {
                if dealerSum <= 3 || dealerSum >= 7 {
                    return .hit
                }
                return .stand
            }
            
            return .hit
        }
        
        // no aces
        
        if playerSum >= 17 {
            return .stand
        }
        
        if playerSum >= 13 {
            if dealerSum >= 7 {
                return .hit
            } else {
                return .stand
            }
        }
        
        if playerSum == 12 {
            if dealerSum <= 3 || dealerSum >= 7 {
                return .hit
            } else {
                return .stand
            }
        }
        
        // player hand <= 11
        return .hit
        
    }
}
