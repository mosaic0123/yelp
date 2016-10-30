//
//  DealCell.swift
//  Yelp
//
//  Created by tingting_gao on 10/30/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate {
    @objc optional func dealCell(dealCell: DealCell, didChangeValue value: Bool)
}

class DealCell: UITableViewCell {

    @IBOutlet weak var dealLabel: UILabel!

    @IBOutlet weak var dealSwitch: UISwitch!

    weak var delegate: DealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        dealSwitch.addTarget(self, action: "switchChanged", for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchChanged() {
        print("Deal switch changed")
        delegate?.dealCell?(dealCell: self, didChangeValue: dealSwitch.isOn)
    }

}
