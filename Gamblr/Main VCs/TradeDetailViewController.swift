//
//  TradeDetailViewController.swift
//  Gamblr
//
//  Created by Erik Fotta on 5/2/22.
//

import UIKit

class TradeDetailViewController: UIViewController {

    var tradeSession = TradeSession()
    var formatter = NumberFormatter()
    var balanceFormatter = NumberFormatter()
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var begBalLabel: UILabel!
    @IBOutlet weak var endBalLabel: UILabel!
    @IBOutlet weak var begPriceLabel: UILabel!
    @IBOutlet weak var endPriceLabel: UILabel!
    @IBOutlet weak var daysTradedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.maximumSignificantDigits = 8
        balanceFormatter.maximumFractionDigits = 2
        symbolLabel.text = tradeSession.cryptoSymbol
        begBalLabel.text = "$\(balanceFormatter.string(from: tradeSession.startingPortfolioBalance as NSNumber)!)"
        endBalLabel.text = "$\(balanceFormatter.string(from: tradeSession.endingPortfolioBalance as NSNumber)!)"
        begPriceLabel.text = "$\(formatter.string(from: tradeSession.cryptoStartingPrice as NSNumber)!)"
        endPriceLabel.text = "$\(formatter.string(from: tradeSession.cryptoEndingPrice as NSNumber)!)"
        daysTradedLabel.text = String(tradeSession.daysTraded)
    }
}
