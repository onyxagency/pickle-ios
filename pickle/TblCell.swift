//
//  TblCell.swift
//  pickle
//
//  Created by Zach Nolan on 4/22/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit

class TblCell: UITableViewCell {

  @IBOutlet var placeImage: UIImageView!
  @IBOutlet var placeName: UILabel!
  @IBOutlet var placeCategory: UILabel!
  @IBOutlet var placeAddress: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
