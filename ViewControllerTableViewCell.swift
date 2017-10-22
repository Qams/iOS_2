//
//  ViewControllerTableViewCell.swift
//  advancedUi
//
//  Created by kamil on 22/10/2017.
//  Copyright © 2017 kamil. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

   
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
