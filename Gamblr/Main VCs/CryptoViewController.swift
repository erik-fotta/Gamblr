//
//  CryptoViewController.swift
//  Gamblr
//
//  Created by Erik Fotta on 4/30/22.
//

import UIKit

class CryptoViewController: UIViewController {

    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var lastBoughtLabel: UILabel!
    @IBOutlet weak var lastSoldLabel: UILabel!
    @IBOutlet weak var currentPortfolioLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var youLabel: UILabel!
    @IBOutlet weak var passiveLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let formatter = NumberFormatter()
    var day: Int = 0
    var coinIndex: Int = 0
    var index: Int = 0
    var portfolioValue: Double = 0.0
    var passiveValue: Double = 1000.0
    var cryptoHeld: Double = 0.0
    var boughtIndex = 0
    var soldIndex = 0
    var held: Bool = false
    var dataStore: [[Double]] = []
    var price_list: [Double] = []
    var tradeSession = TradeSession()
    var cryptoPrice: Double = 0
    var coinList: [String] = ["BTC", "ADA", "CAR", "DOGE", "CPY", "GEM", "PLA", "TRAC", "AVAX", "XTC", "LTC", "DASH", "LINK", "AMO", "AMP" , "ALGO", "MANA", "ETH", "SOL", "BAND"]
    
    struct Response: Codable {
        let Data: MyResult
    }
    
    struct MyResult: Codable {
        let TimeTo: Int
        let Data: [MyNewResult]
    }
    
    struct MyNewResult: Codable {
        let close: Double
    }
    
    private func getData(url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { [self] data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("Failed to convert: \(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }
            var prices: [Double] = []
            for item in json.Data.Data {
                prices.append(item.close)
            }
            priceMover(prices: prices)
        })
        task.resume()
    }
 
    func priceMover(prices: [Double]) {
        dataStore.append(prices)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.maximumFractionDigits = 2
        for symbol in coinList {
            let urlString = "https://min-api.cryptocompare.com/data/v2/histoday?fsym=\(symbol)&tsym=USD&limit=90&api_key=24543762f05b931c28076af579eb185f52d3818da25fec3910bfb2cfe7663050"
            getData(url: urlString)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentPortfolioLabel.text = "$\(formatter.string(from: portfolioValue as NSNumber)!)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tradeSession.endingPortfolioBalance = portfolioValue
        tradeSession.cryptoEndingPrice = dataStore[coinIndex][index]
        tradeSession.daysTraded = day - 1
        tradeSession.cryptoSymbol = coinList[coinIndex]
        startButton.isEnabled = true
    }
    
    func updateUserInterface(cIndex: Int) {
        if day >= 90 {
            dayLabel.text = "\(day) / 90"
            buyButton.isEnabled = false
            sellButton.isEnabled = false
            holdButton.isEnabled = false
            oneButtonAlert(title: "End of Period", message: "You have reached the end of your 90 day trading window. Return to the Home screen to see your progress and start new trades")
            return
        } else {
            dayLabel.text = "\(day) / 90"
            day += 1
        }
        currentPortfolioLabel.text = "$\(formatter.string(from: portfolioValue as NSNumber)!)"
        lastBoughtLabel.text = String(dataStore[cIndex][boughtIndex])
        lastSoldLabel.text = String(dataStore[cIndex][soldIndex])
        currentPriceLabel.text = String(dataStore[cIndex][index])
        symbolLabel.text = coinList[cIndex]
        if held {
            buyButton.isEnabled = false
            sellButton.isEnabled = true
        } else {
            buyButton.isEnabled = true
            sellButton.isEnabled = false
        }
        passiveLabel.text = String("\(formatter.string(from: (dataStore[coinIndex][index] / dataStore[coinIndex][0] * 100 - 100) as NSNumber)!)%")
        youLabel.text = String("\(formatter.string(from: (portfolioValue / 1000 * 100 - 100) as NSNumber)!)%")
        if index > 0 {
            if dataStore[cIndex][index] > dataStore[cIndex][index - 1] {
                currentPriceLabel.textColor = .green
            } else {
                currentPriceLabel.textColor = .red
            }
        }
    }
    
    @IBAction func holdButtonPressed(_ sender: Any) {
        if currentPriceLabel.text == "_________" {
            print("Start a game first")
        } else {
            if held {
                portfolioValue = cryptoHeld * dataStore[coinIndex][index]
            }
            updateUserInterface(cIndex: coinIndex)
            index += 1
        }
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        if currentPriceLabel.text == "_________" {
            print("Start a game first")
        } else {
            holdButton.isEnabled = true
            cryptoHeld = portfolioValue / dataStore[coinIndex][index]
            held = true
            if held {
                portfolioValue = cryptoHeld * dataStore[coinIndex][index]
            }
            boughtIndex = index
            updateUserInterface(cIndex: coinIndex)
            index += 1
        }
    }
    
    @IBAction func sellButtonPressed(_ sender: Any) {
        if currentPriceLabel.text == "_________" {
            print("Start a game first")
        } else {
            holdButton.isEnabled = true
            held = false
            if held {
                portfolioValue = cryptoHeld * dataStore[coinIndex][index]
            }
            cryptoHeld = 0
            soldIndex = index
            updateUserInterface(cIndex: coinIndex)
            index += 1
        }
    }
    
    func start() {
        tradeSession.started = true
        day = 0
        dayLabel.text = "0 / 90"
        coinIndex = Int.random(in: 0...coinList.count - 1)
        symbolLabel.text = coinList[coinIndex]
        currentPriceLabel.text = String(dataStore[coinIndex][index])
        symbolLabel.text = "???"
        lastSoldLabel.text = "_________"
        lastBoughtLabel.text = "_________"
        tradeSession.cryptoStartingPrice = dataStore[coinIndex][index]
        tradeSession.startingPortfolioBalance = portfolioValue
        if held {
            held = false
            if held {
                portfolioValue = cryptoHeld * dataStore[coinIndex][index]
            }
            cryptoHeld = 0
            updateUserInterface(cIndex: coinIndex)
        } else {
            cryptoHeld = portfolioValue / dataStore[coinIndex][index]
            updateUserInterface(cIndex: coinIndex)
        }
        index = 0
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        start()
        startButton.isEnabled = false
    }
}


