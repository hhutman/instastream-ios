//
//  LiveVideoTableViewCell.swift
//  InstaStream
//
//  Created by prasanth inavolu on 05/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import UIKit

class LiveVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var commentUserName: UILabel!
    @IBOutlet weak var commentsByUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
