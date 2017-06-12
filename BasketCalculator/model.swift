//
//  model.swift
//  BasketCalculator
//
//  Created by ilo on 12/06/2017.
//  Copyright © 2017 Big Bear Labs. All rights reserved.
//

import Foundation



struct PurchasableItem: Hashable, Equatable {
  let name: String
  let price: Double
  
  var hashValue: Int {
    // quick+dirty: offload to the name string.
    return self.name.hashValue
  }
  
  static func ==(a: PurchasableItem, b: PurchasableItem) -> Bool {
    return
      a.name == b.name
        && a.price == b.price
  }
}



struct Basket {
  
  var ordersByItem: [PurchasableItem : Int] = [:]
  
  mutating func update(item: PurchasableItem, withQuantity quantity: Int) {
    self.ordersByItem[item] = quantity
  }
  
  var totalInReferenceCurrency: Double {
    var total = Double(0)
    for (item, quantity) in ordersByItem {
      total += item.price * Double(quantity)
    }
    return total
  }
  
  func total(inRate rate: RateData) -> Double {
    if rate.fromCurrency != "USD" {
      fatalError("must use a rate that converts from USD")
    }
    return totalInReferenceCurrency * rate.multiplier
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
