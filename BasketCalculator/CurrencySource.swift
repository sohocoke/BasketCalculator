//
//  CurrencySource.swift
//  BasketCalculator
//
//  Created by ilo on 12/06/2017.
//  Copyright © 2017 Big Bear Labs. All rights reserved.
//

import Foundation



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

