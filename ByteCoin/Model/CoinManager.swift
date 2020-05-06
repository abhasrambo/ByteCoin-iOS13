//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ price: String, _ currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D19E1558-6E06-4C98-AEAD-B5B009614B04"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        
        let urlString: String = "\(baseURL)/\(currency)?apikey=\(apiKey)"
         if let url = URL(string: urlString) {
                   
                   //Create a new URLSession object with default configuration.
                   let session = URLSession(configuration: .default)
                   
                   //Create a new data task for the URLSession
                   let task = session.dataTask(with: url) { (data, response, error) in
                       if error != nil {
                           print(error!)
                           return
                       }
                    if let safeData = data {
                        if let bitCoinPrice = self.parseJson(safeData){
                         let priceString = String(format: "%.2f", bitCoinPrice)
                            self.delegate?.didUpdatePrice(priceString, currency)
                        }
                    }
                       
                   }
                   task.resume()
               }
    }
    
        func parseJson(_ data: Data) -> Double? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: data)
                let lastPrice = decodedData.rate
        
                return lastPrice
            } catch {
                print(error)
                return nil
            }
        
    }
}
