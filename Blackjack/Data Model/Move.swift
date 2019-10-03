//
//  Move.swift
//  Blackjack
//
//  Created by Will Said on 10/1/19.
//  Copyright © 2019 Will Said. All rights reserved.
//

import Foundation

// todo add split, double, etc
enum Move: String {
    
    case hit   = "hit"
    case stand = "stand"
    case hint  = "hint"
    
    init?() {
        if let move = Move(rawValue: Input.getCurrentLine()) {
            self = move
        } else {
            return nil
        }
    }
}
