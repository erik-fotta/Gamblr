//
//  ViewController.swift
//  Gamblr
//
//  Created by Erik Fotta on 4/29/22.
//

import UIKit

class HomeViewController: UIViewController {

    var percentFormatter = NumberFormatter()
    var portfolioValue: Double = 1000.0
    var passiveValue: Double = 1000.0
    var tradeHistory: [TradeSession] = []
    
    @IBOutlet weak var portfolioValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var passiveLabel: UILabel!
    @IBOutlet weak var pvpLabel: UILabel!
    @IBOutlet weak var portfolioPercentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        percentFormatter.maximumFractionDigits = 2
        portfolioValueLabel.text = String(portfolioValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        portfolioValueLabel.text = "$\(percentFormatter.string(from: portfolioValue as NSNumber)!)"
        
        let portfolioPercent: Double = (((portfolioValue - 1000) / 1000) * 100)
        portfolioPercentLabel.text = "\(percentFormatter.string(from: portfolioPercent as NSNumber)!)%"
        if portfolioPercent > 0.0 {
            portfolioPercentLabel.textColor = .green
        } else if portfolioPercent == 0.0 {
            portfolioPercentLabel.textColor = .white
        } else {
            portfolioPercentLabel.textColor = .red
        }
        
        let pvpPercent: Double = (((portfolioValue / passiveValue) - 1) * 100)
        pvpLabel.text = "\(percentFormatter.string(from: pvpPercent as NSNumber)!)%"
        if pvpPercent > 0.0 {
            pvpLabel.textColor = .green
        } else if pvpPercent == 0.0 {
            pvpLabel.textColor = .white
        } else {
            pvpLabel.textColor = .red
        }
        
        let passivePercent: Double = (((passiveValue - 1000) / 1000) * 100)
        passiveLabel.text = "\(percentFormatter.string(from: passivePercent as NSNumber)!)%"
        if passivePercent > 0.0 {
            passiveLabel.textColor = .green
        } else if passivePercent == 0.0 {
            passiveLabel.textColor = .white
        } else {
            passiveLabel.textColor = .red
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCrypto" {
            let destination = segue.destination as! CryptoViewController
            destination.portfolioValue = portfolioValue
        }
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! TradeDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.tradeSession = tradeHistory[selectedIndexPath.row]
        }
    }
    
    @IBAction func unwindFromCrypto(segue: UIStoryboardSegue) {
        let source = segue.source as! CryptoViewController
        if source.tradeSession.started == true {
            portfolioValue = source.tradeSession.endingPortfolioBalance
            portfolioValueLabel.text = String(portfolioValue)
            passiveValue = passiveValue / source.tradeSession.cryptoStartingPrice * source.tradeSession.cryptoEndingPrice
            tradeHistory.reverse()
            tradeHistory.append(source.tradeSession)
            tradeHistory.reverse()
        }
        saveData()
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("trades").appendingPathExtension("json")
        let documentURL1 = directoryURL.appendingPathComponent("portfolio").appendingPathExtension("json")
        let documentURL2 = directoryURL.appendingPathComponent("passive").appendingPathExtension("json")
        
        let jsonDecoder = JSONDecoder()
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        guard let data1 = try? Data(contentsOf: documentURL1) else {return}
        guard let data2 = try? Data(contentsOf: documentURL2) else {return}
        
        do {
            tradeHistory = try jsonDecoder.decode(Array<TradeSession>.self, from: data)
            portfolioValue = try jsonDecoder.decode(Double.self, from: data1)
            passiveValue = try jsonDecoder.decode(Double.self, from: data2)
            tableView.reloadData()
        } catch {
            print("ERROR: Could not load data \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("trades").appendingPathExtension("json")
        let documentURL1 = directoryURL.appendingPathComponent("portfolio").appendingPathExtension("json")
        let documentURL2 = directoryURL.appendingPathComponent("passive").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(tradeHistory)
        let data1 = try? jsonEncoder.encode(portfolioValue)
        let data2 = try? jsonEncoder.encode(passiveValue)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        do {
            try data1?.write(to: documentURL1, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        do {
            try data2?.write(to: documentURL2, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        oneButtonAlert(title: "Info", message:
"""
In order to help you gauge your ability against the market, you are provided two metrics:

Passive: tracks the portfolio invested passively; buys when you open a trading session, sells when you close

Portfolio Vs. Passive: tracks the percentage by which your trading is over or under performing the passive portfolio
"""
        )
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        cell.symbolLabel.text = tradeHistory[indexPath.row].cryptoSymbol
        let percent = (((tradeHistory[indexPath.row].endingPortfolioBalance - tradeHistory[indexPath.row].startingPortfolioBalance) / tradeHistory[indexPath.row].startingPortfolioBalance ) * 100)
        cell.percentLabel.text = "\(percentFormatter.string(from: percent as NSNumber)!)%"
        if percent > 0.0 {
            cell.percentLabel.textColor = .green
        } else if percent == 0.0 {
            cell.percentLabel.textColor = .white
        } else {
            cell.percentLabel.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeHistory.count
    }
}
