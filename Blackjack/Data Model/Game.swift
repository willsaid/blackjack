//
//  Game.swift
//  Blackjack
//
//  Created by Will Said on 10/1/19.
//  Copyright © 2019 Will Said. All rights reserved.
//

import Foundation

struct Game {
    
    let maxCoins: Double = 1000
    
    func play() {
        
        welcome()
        
        guard wantsToPlay() else {
            return
        }
        
        var coins = maxCoins
        
        // Game Loop - runs until losing or quitting
        while true {
            
            if coins <= 0 {
                print("You have no more coins! Game Over")
                return
            }
            
            let betSize = getBetSize(currentCoins: coins)
            var dealersHand = Hand(type: .dealer)
            if dealersHand.isBlackjack {
                // dealer auto wins
                print("Dealer automatically won by blackjack 21!")
                gameOutcome(winner: .dealer, playerCoins: &coins, betSize: betSize, wasPlayerBlackjack: false)
                continue
            }
            
            print("Dealer's Hand: \(dealersHand.cards[0].name), ?")
            
            let playersHand = finalizePlayerHand(dealerHand: dealersHand)
            
            if playersHand.sum > 21 {
                // bust
                print("You busted! Player hand = \(playersHand.sum)")
                gameOutcome(winner: .dealer, playerCoins: &coins, betSize: betSize, wasPlayerBlackjack: false)
                continue
            }
            
            // hard 17
            while dealersHand.sum <= 17 {
                // keep hitting
                dealersHand.hit()
                print("Dealer hit, now at \(dealersHand.sum)")
            }
            
            if dealersHand.sum > 21 || playersHand.sum > dealersHand.sum {
                // player won
                gameOutcome(winner: .player, playerCoins: &coins, betSize: betSize, wasPlayerBlackjack: playersHand.sum == 21)
            } else if playersHand.sum == dealersHand.sum {
                // get your money back
                print("Tie, no change in coins")
            } else {
                // dealer won
                gameOutcome(winner: .dealer, playerCoins: &coins, betSize: betSize, wasPlayerBlackjack: false)
            }
            
        }
    }
    
    private func welcome() {
        print("Welcome to Blackjack")
        print("Press \"p\" to play, \"h\" for help, and \"q\" to quit")
    }
    
    private func wantsToPlay() -> Bool {
        var input = Input()
        while input == .error {
            print("Invalid option, try again")
            input = Input()
        }
        
        switch input {
            case .quit: break
            case .help: help(); break
            case .error: print("Invalid option, try again")
            case .play: return true
        }
        
        return false
    }
    
    private func getBetSize(currentCoins: Double) -> Double {
        print("You have \(currentCoins) coins. How much would you like to bet, from 0 - \(min(maxCoins, currentCoins))?")
        
        var input = Input.getCurrentLine()
        while Double(input) == nil || Double(input)! > currentCoins {
            print("Invalid bet size, try again.")
            input = Input.getCurrentLine()
        }
        
        return Double(input)!
    }
    
    private func finalizePlayerHand(dealerHand: Hand) -> Hand {
        var playersHand = Hand(type: .player)
        
        while playersHand.sum <= 21 && playersHand.standing == false {
            print("Your Hand: \(playersHand.cards.reduce("", {$0 + $1.name + ", "}).dropLast(2))")
            print("Would you like to \"hit\", \"stand\", or receive a \"hint\"?")
            switch Move() {
                case .hit:
                    playersHand.hit()
                case .stand:
                    playersHand.stand()
                case .hint:
                    playersHand.getHint(dealerHand: dealerHand)
                case .none:
                    print("Invalid choice.")
                    continue
            }
            
        }
        
        return playersHand
    }
    
    private func gameOutcome(winner: Player, playerCoins: inout Double, betSize: Double, wasPlayerBlackjack: Bool) {
        let blackjackBonusMultiple = 1.5
        print("Winner was the \(winner.rawValue)!")
        switch winner {
            case .player:
                playerCoins += wasPlayerBlackjack ? betSize * blackjackBonusMultiple : betSize
            case .dealer:
                playerCoins -= betSize
        }
        print("Player coins is now \(playerCoins)")
    }
    
    private func help() {
        print("""
                This game makes several simplifications for now.
                It assumes a continuous shuffle machine rather than a fixed set of decks.
                Dealer hits on a hard 17.
                No splitting, no doubling, no surrendering, etc.
                Only original bets are lost on dealer blackjack, although the dealer wins immediately.
              """)
    }
}

