//
//  Card.swift
//  Blackjack
//
//  Created by Will Said on 10/1/19.
//  Copyright © 2019 Will Said. All rights reserved.
//

import Foundation

enum Card {
    case ace(name: String, soft: Int, hard: Int) // either 1 or 11
    case notAce(name: String, value: Int)
}

extension Card {
    static let possibleValues: [Card] = [
        .ace(name: "Ace", soft: 1, hard: 11),
        .notAce(name: "1"    , value: 1),
        .notAce(name: "2"    , value: 2),
        .notAce(name: "3"    , value: 3),
        .notAce(name: "4"    , value: 4),
        .notAce(name: "5"    , value: 5),
        .notAce(name: "6"    , value: 6),
        .notAce(name: "7"    , value: 7),
        .notAce(name: "8"    , value: 8),
        .notAce(name: "9"    , value: 9),
        .notAce(name: "10"   , value: 10),
        .notAce(name: "Jack" , value: 10),
        .notAce(name: "Queen", value: 10),
        .notAce(name: "King" , value: 10)
    ]
    
    var softValue: Int {
        switch self {
            case .ace(name: _, soft: let soft, hard: _): return soft
            case .notAce(name: _, value: let val): return val
        }
    }
    
    var hardValue: Int {
        switch self {
            case .ace(name: _, soft: _, hard: let hard): return hard
            case .notAce(name: _, value: let val): return val
        }
    }
    
    var name: String {
        switch self {
            case .ace(name: let name, soft: _, hard: _): return name
            case .notAce(name: let name, value: _): return name
        }
    }
    
    var isAce: Bool {
        name == "Ace"
    }
    
    init() {
        // Chooses a card from an uniform distribution
        // See https://github.com/apple/swift-evolution/blob/master/proposals/0202-random-unification.md
        self = Self.possibleValues.randomElement()!
    }
    
}
