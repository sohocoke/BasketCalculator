//
//  PurchasableItemViewController.swift
//  BasketCalculator
//
//  Created by ilo on 12/06/2017.
//  Copyright © 2017 Big Bear Labs. All rights reserved.
//

import UIKit

class PurchasableItemViewController: UIViewController {

  
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var itemQuantityLabel: UILabel!
  
  var item: PurchasableItem?

  var quantity: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }

  func setupViews() {
    if let item = item {
      itemTitleLabel.text = item.name
      itemQuantityLabel.text = String(quantity)
    }
  }
  
  @IBAction func action_changeQuantity(_ sender: UIStepper) {
    self.quantity = Int(sender.value)
    self.setupViews()
    
    notifyItemQuantityChange()
  }
  
  func notifyItemQuantityChange() {
    // prototypical implementation foregoes delegate interface and makes assumptions about the parent.
    // don't do this in production!
    (self.parent as! ViewController).itemQuantityChanged(item: self.item!, quantity: self.quantity)
  }
}
