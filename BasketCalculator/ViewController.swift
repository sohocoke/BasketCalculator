//
//  ViewController.swift
//  BasketCalculator
//
//  Created by ilo on 12/06/2017.
//  Copyright © 2017 Big Bear Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // * in order to avoid dealing with a time-consuming table view implementation for rendering items in a list,
    // * set up the item view controllers according to the tactical convention implemented in Main.storyboard:
    // - each item is rendered via an embed segue to the PurchasableItemViewController.
    // - each segue is named "embed_item_n", where n is the index into the purchasableItems array.
    // NOT_FOR_PRODUCTION this is for fast prototyping, and clearly will obviously not scale on the dimension of items.
    if let itemViewController = segue.destination as? PurchasableItemViewController,
      let segueId = segue.identifier, segueId.hasPrefix("embed_item_")
    {
      setup(itemViewController: itemViewController, withItemForSegueId: segueId)
    }
    
    super.prepare(for: segue, sender: sender)
  }

  func setup(itemViewController: PurchasableItemViewController, withItemForSegueId segueId: String) {
    let itemIndex = Int(segueId.components(separatedBy: "_").last!)!
    let item = purchasableItems[itemIndex]
    itemViewController.item = item
  }
  
  
  var purchasableItems = [
    PurchasableItem(name: "Peas", price: 0.95),
    PurchasableItem(name: "Eggs", price: 2.10),
    PurchasableItem(name: "Milk", price: 1.30),
    PurchasableItem(name: "Beans", price: 0.73),
  ]
  
  
  func itemQuantityChanged(item: PurchasableItem, quantity: Int) {
    print("TODO update basket.")
    self.checkoutViewController.basket.update(item: item, withQuantity: quantity)
    
  }
  
  
  lazy var checkoutViewController: CheckoutViewController = {
    self.childViewControllers.filter { $0 is CheckoutViewController } [0] as! CheckoutViewController
  }()

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
}

