//
//  TradeSession.swift
//  Gamblr
//
//  Created by Erik Fotta on 5/2/22.
//

import Foundation

class TradeSession: Codable {
    var startingPortfolioBalance: Double
    var endingPortfolioBalance: Double
    var cryptoStartingPrice: Double
    var cryptoEndingPrice: Double
    var daysTraded: Int
    var cryptoSymbol: String
    var started: Bool
    
    init() {
        startingPortfolioBalance = 0.0
        endingPortfolioBalance = 0.0
        cryptoStartingPrice = 0.0
        cryptoEndingPrice = 0.0
        daysTraded = 0
        cryptoSymbol = ""
        started = false
    }
}
