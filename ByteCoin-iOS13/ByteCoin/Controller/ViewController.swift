//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcointLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        currencyLabel.text = coinManager.currencyArray[0]
        coinManager.fecthCoinPrice(for:  coinManager.currencyArray[0])
        // Do any additional setup after loading the view.
    }
    
    
}

// MARK: - Picker delegates

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.fecthCoinPrice(for:coinManager.currencyArray[row])
    }
    
    
}

extension ViewController: CoinManagerDelegate {
    
    func didFetchCurrencyPrice(exchangeRate: ExchangeRate) {
        DispatchQueue.main.async {
            self.currencyLabel.text = exchangeRate.currentQuote
            self.bitcointLabel.text = String(format: "%.2f", exchangeRate.rate)
        }
    }
}
