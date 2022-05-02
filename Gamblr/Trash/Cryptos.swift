//
//  Cryptos.swift
//  Gamblr
//
//  Created by Erik Fotta on 4/30/22.
//

import Foundation

//class Cryptos {
//    private struct Returned: Codable {
//        //var count: Int
//        //var next: String?
//        var Data: [Data]
//    }
//    
//    struct Data: [String:Double] {
//        var close: Double
//    }
//        
//    var count = 0
//    var urlString = "https://min-api.cryptocompare.com/data/v2/histoday?fsym=BTC&tsym=USD&limit=10&api_key=24543762f05b931c28076af579eb185f52d3818da25fec3910bfb2cfe7663050"
//    var cryptoArray: [Data] = []
//    var isFetching = false
//    
//    func getData(completed: @escaping () -> ()) {
//        guard isFetching == false else {
//            return
//        }
//        isFetching = true
//        guard let url = URL(string: urlString) else {
//            print("😡 ERROR: Couldn't not create a URL from \(urlString)")
//            isFetching = false
//            completed()
//            return
//        }
//        let session = URLSession.shared
//        let task = session.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("😡 ERROR: \(error.localizedDescription)")
//            }
//            do {
//                let returned = try JSONDecoder().decode(Returned.self, from: data!)
//                print(returned)
//                //self.count = returned.count
//                //self.urlString = returned.next ?? ""
//                //self.cryptoArray = self.cryptoArray + [returned.Data["Data"]!]
//            } catch {
//                print("😡 JSON ERROR: \(error.localizedDescription)")
//            }
//            self.isFetching = false
//            completed()
//        }
//        
//        task.resume()
//    }
//    
//}
