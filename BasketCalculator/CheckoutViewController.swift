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
  var rateDatasByCurrencyPair: [String : RateData] = [:]
  
  
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
    self.totalLabel.text =
      "Total: \(self.basket.totalInReferenceCurrency.description)"
  }
}


// MARK: - currency selection using a UIPicker
extension CheckoutViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  
  func setupCurrencySelector() {
    
    // * fetch data,
    
    // * parse data,
    
    // * set state.
    
  }

  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 100
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "picker item"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    print("TODO recalculate total")
  }
}



struct RateData {
  let currencyPair: String
  let multiplier: Double
}
