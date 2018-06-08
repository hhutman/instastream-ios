//
//  ChoosePagesForFbTableViewCell.swift
//  InstaStream
//
//  Created by Rapid Dev on 04/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit

class ChoosePagesForFbTableViewCell: UITableViewCell {

    @IBOutlet weak var fbPagesImageView: AsyncImageView!
    @IBOutlet weak var fbPageName: UILabel!
    @IBOutlet weak var fbPageCheckBox: UIImageView!
    @IBOutlet weak var checkBoxActive: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
