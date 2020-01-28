//
//  OrderTableViewCell.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-17.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWith(order: Order){
        producerLabel.text = "Producer: \(order.producerName ?? "")"
        productNameLabel.text = "Product: \(order.name ?? "")"
        amountLabel.text = "\(order.amount ?? 0)"
        totalPriceLabel.text = "\(order.price ?? 0)"
        
        switch order.status {
        case .waiting:
            statusLabel.text = "Status: Waiting  "
            statusLabel.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 0.5)
        case .confirmed:
            statusLabel.text = "Status: Confirmed! Welcome to pickup your order! "
            statusLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .denied:
            statusLabel.text = "Status: Denied  "
            statusLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .delivered:
            statusLabel.text = "Status: Delivered. Thank you for your purchase! "
            statusLabel.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        
        
    }


}
