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

