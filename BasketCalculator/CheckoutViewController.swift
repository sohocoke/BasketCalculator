//
//  CheckoutViewController.swift
//  BasketCalculator
//
//  Created by ilo on 12/06/2017.
//  Copyright © 2017 Big Bear Labs. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {

  
  // MARK: - view
  
  @IBOutlet weak var totalLabel: UILabel!
  
  @IBOutlet weak var changeCurrencyButton: UIButton!
  @IBOutlet weak var currencySelector: UIPickerView!

  var isInCurrencyChangeWorkflow: Bool = false {
    didSet {
      if self.isInCurrencyChangeWorkflow {
        // * user wants to start change workflow -- show the selector.
        currencySelector.isHidden = false
        changeCurrencyButton.setTitle("Confirm", for: .normal)
      } else {
        // * user wants to end change workflow -- hide the selector.
        currencySelector.isHidden = true
        changeCurrencyButton.setTitle("Change Currency", for: .normal)
      }
    }
  }
  
  // MARK: - data
  
  var basket = Basket() {
    didSet {
      refreshTotal()
    }
  }

  var rateDatas: [RateData] = [] {
    didSet {
      self.currencySelector.reloadAllComponents()
    }
  }
  var selectedRate: RateData? = nil {
    didSet {
      refreshTotal()
    }
  }
  
  
  // MARK: - lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupCurrencySelector()  // CONSIDER deferring setup until currency selector shown.
  }
  
  
  // MARK: - actions
  
  @IBAction func action_changeCurrency(_ sender: Any) {
    self.isInCurrencyChangeWorkflow = !self.isInCurrencyChangeWorkflow
  }
  
  
  // MARK: - rendering
  
  func refreshTotal() {
    let rate = self.selectedRate ?? identityRate
    let totalString = self.basket.total(inRate: rate)
    self.totalLabel.text = "Total: \(rate.toCurrency) \(totalString)"
  }
  
  
  // MARK: - collaborators
  
  let currencySource = SimpleCurrencySource()
  
  let identityRate = RateData(currencyPair: "USDUSD", multiplier: 1)
}


// MARK: - currency selection using a UIPicker
extension CheckoutViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  
  func setupCurrencySelector() {
    
    // * fetch data,
    // * parse data,
    // * set state.
    currencySource.fetchRates { [unowned self] rateDatas in
      self.rateDatas = rateDatas
      
    }
    
  }

  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.rateDatas.count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.rateDatas[row].toCurrency
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.selectedRate = rateDatas[row]
  }
  
}



struct RateData {
  let currencyPair: String
  let multiplier: Double
  
  var fromCurrency: String {
    return currencyPair.substring(to: currencyPair.index(currencyPair.startIndex, offsetBy: 3))
  }
  
  var toCurrency: String {
    return currencyPair.substring(from: currencyPair.index(currencyPair.startIndex, offsetBy: 3))
  }
}



// * start with a quick version that reads of the placeholder file.
class SimpleCurrencySource {
  
  func fetchRates(completionHandler: ([RateData]) -> Void) {
    
    let urlData = try! Data(contentsOf: ratesUrl)
    let jsonObject = try! JSONSerialization.jsonObject(with: urlData, options: []) as! [String : Any]
    
    let rates = (jsonObject["quotes"] as! [String : Double]).map { (k, v) in
      return RateData(currencyPair: k, multiplier: v)
    }
    
    // since ref currency is usd, we just need the usd*** rates.
    let usdRates = rates.filter { $0.fromCurrency == "USD" }
    
    completionHandler(usdRates)
  }
  
  var ratesUrl: URL {
    // placeholder version serves from static file in app bundle.
//    return Bundle.main.url(forResource: "rates", withExtension: "json")!
    
    // naive version returns http string. ATS needs to make an exception here.
    // obviously, access key etc needs to be made configurable for a real app.
    return URL(string: "http://apilayer.net/api/live?access_key=07f1bc91f9ec6ea11cfb10774497fd19")!
  }

}

