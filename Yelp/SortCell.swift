//
//  SortCell.swift
//  Yelp
//
//  Created by tingting_gao on 10/30/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SortCell: UITableViewCell {

    @IBOutlet weak var checkView: UIImageView!

    @IBOutlet weak var sortLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
