//
//  ProductLocationsListTableViewCell.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-25.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class ProductLocationsListTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var RekoNameLabel: UILabel!
    var radioButtonCheckedImage: UIImage?
    var radioButtonUnCheckedImage: UIImage?
    var isChecked = false
    var radioButtonDelegate: RadioButtonStateDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioButtonCheckedImage = UIImage(named: "radio_button_checked")
        radioButtonUnCheckedImage = UIImage(named: "radio_button_unchecked")
        radioButton.setBackgroundImage(radioButtonCheckedImage, for: .selected)
        radioButton.setBackgroundImage(radioButtonUnCheckedImage, for: .normal)
        
    }

  
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            self.setSelected(false, animated: false)
        }

    }

    
    func setUpCellFrom(rekoLocation: RekoLocation, tag: Int){
        self.RekoNameLabel.text = rekoLocation.name
        isChecked = rekoLocation.isSelected
        radioButton.isSelected = isChecked
        self.tag = tag
    }
    
    @IBAction func radioButtonPressed(_ sender: UIButton) {
        isChecked = !isChecked
        radioButton.isSelected = isChecked
        radioButtonDelegate?.radiobuttonStateChanged(atRow: self.tag)
        print(self.tag)
    }
}
