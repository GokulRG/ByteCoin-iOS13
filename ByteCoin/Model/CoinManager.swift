//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(with error: Error)
    func didGetPrice(_ coinManager: CoinManager, _ priceData: PriceData)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "89CF5007-CB85-4A3F-8A1A-314052DD521F"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(with: error!)
                    return
                }
                
                if let safeData = data {
                    if let priceData = self.parseJSON(priceData: safeData) {
                        self.delegate?.didGetPrice(self, priceData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(priceData: Data) -> PriceData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PriceData.self, from: priceData)
            return decodedData
        } catch {
            delegate?.didFailWithError(with: error)
            return nil
        }
    }
}
