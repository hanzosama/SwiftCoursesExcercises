//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error:Error)
    func didFetchCurrencyPrice(exchangeRate: ExchangeRate)
}

extension CoinManagerDelegate{
    func didFailWithError(error:Error){
        
    }
    
    func didFetchCurrencyPrice(exchangeRate: ExchangeRate){
        
    }
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "93834397-80E8-4490-A43A-DACA432DD3B6"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func fecthCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task  = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    print(String(data:safeData,encoding: .utf8) ?? "NO DATA")
                    if let exchangeData = self.parseExchangeRateJSON(with: safeData){
                        self.delegate?.didFetchCurrencyPrice(exchangeRate: exchangeData)
                    }
                }
                
            }
            
            task.resume()
        }
        
        
    }
    
    func parseExchangeRateJSON(with  data: Data) -> ExchangeRate? {
        let decoder = JSONDecoder()
        do
        {
            return try decoder.decode(ExchangeRate.self, from: data)
        }catch{
            self.delegate?.didFailWithError(error: error)
        }
        return nil
    }
    
}

struct ExchangeRate: Codable {
    let rate : Double
    let currentQuote:String
    enum CodingKeys: String, CodingKey {
        case currentQuote = "asset_id_quote"
        case rate
    }
}
