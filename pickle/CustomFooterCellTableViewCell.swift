//
//  CustomFooterCellTableViewCell.swift
//  pickle
//
//  Created by Zach Nolan on 9/22/15.
//  Copyright © 2015 Onyx. All rights reserved.
//

import UIKit

class CustomFooterCellTableViewCell: UITableViewCell {

  @IBOutlet var pickleButton: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
