//
//  TestCell.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-03.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell{

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    @IBOutlet weak var priceTagLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var AmountLeftLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.productImageView.isHidden = true
    
    }
    
    func configureWith(product:Product){
        self.productNameLabel.text = product.name
        self.productNameLabel.adjustsFontSizeToFitWidth = true
        self.priceTagLabel.text = "\(product.price ?? 0 )"
        self.producerNameLabel.text = "producer: \(product.producerName ?? "")"
        self.addPicture(product: product)
    }

    func addPicture(product:Product){
        guard let imageURL = product.imageUrl else{
            productImageView.isHidden = true
            return}
        guard let url = URL(string: imageURL) else{return}
        ImageLoader.loadPictureFrom(url: url, into: self.productImageView) { (didComplete) in
            if didComplete{
                self.productImageView.isHidden = false
            }
        }
    }
    
    func configureForProducerWith(product: Product){
        self.productNameLabel.text = product.name
        self.priceTagLabel.text = "\(product.price ?? 0 )"
        AmountLeftLabel.isHidden = false
        self.producerNameLabel.text = product.producerName
        AmountLeftLabel.text = "Amount left: \(product.amount ?? 0 )"
        addPicture(product: product)
    }
    
    
}
