//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUpdatePrice(_ price: String, currency: String)
    func didFailWithError(error: Error)
    
}
struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    var bitcoinUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        
        
        let newurlString = bitcoinUrl + currency
        
        
        if let url = URL(string: newurlString) {
            
            
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                
                if error != nil {
                    
                    print(error!)
                    return
                    
                }
                if let safeData = data {
                    
                    if let lastPrice = self.parseJSON(safeData) {
                        
                        let priceString = String(format: "%.2f", lastPrice)
                        
                        self.delegate?.didUpdatePrice(priceString, currency: currency)
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.last
            return lastPrice
            
        } catch {
            
            delegate?.didFailWithError(error: error)
        }
        
        return nil
    }
    
}
