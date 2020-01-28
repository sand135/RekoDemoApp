//
//  producersOrderTableViewCell.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-24.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class producersOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureForProducerWith(order: Order){
        if let userName = order.user?.name {
            customerNameLabel.text = userName
        }
        productNameLabel.text = order.name
        
        amountLabel.text = "\(order.amount ?? 0)"
        priceLabel.text = "\(order.price ?? 0)"
        
        switch order.status {
        case .waiting:
            statusLabel.text = "Status: Waiting  "
            statusLabel.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 0.5028158551)
        case .confirmed:
            statusLabel.text = "Status: Confirmed to customer. "
            statusLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .denied:
            statusLabel.text = "Status: Denied. Need action! "
            statusLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .delivered:
            statusLabel.text = "Status: Delivered "
            statusLabel.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    

}
