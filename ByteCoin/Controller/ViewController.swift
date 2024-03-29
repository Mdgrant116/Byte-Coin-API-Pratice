//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()
    var selectedCurrency: String?
    
    @IBOutlet var bitCoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currencyLabel.text = selectedCurrency ?? "USD"
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

}

//MARK: - Picker Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
        
        selectedCurrency = "\(coinManager.getCoinPrice(for: coinManager.currencyArray[row]))"
    }
    
}

//MARK: - Coin Manager Delegate


extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(_ price: String, currency: String) {
        
        DispatchQueue.main.async {
            
            self.bitCoinLabel.text = price
            self.currencyLabel.text = currency
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
        
    }
    
}

