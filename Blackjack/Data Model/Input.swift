//
//  Input.swift
//  Blackjack
//
//  Created by Will Said on 10/1/19.
//  Copyright © 2019 Will Said. All rights reserved.
//

import Foundation

enum Input: String {
    case quit = "q" // exit process
    case help = "h" // print rules
    case play = "p"
    case error
    
    init() {
        self = Input(rawValue: Self.getCurrentLine()) ?? .error
    }
    
    static func getCurrentLine() -> String {
        /// read data from stdin,
        /// initialize the data to a string,
        /// and drop the newline chars
        let data = FileHandle.standardInput.availableData
        let strData = String(data: data, encoding: .utf8)!
        return strData.trimmingCharacters(in: .newlines)
    }
}
