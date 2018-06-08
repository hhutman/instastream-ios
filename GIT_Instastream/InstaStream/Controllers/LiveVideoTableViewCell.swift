//
//  LiveVideoTableViewCell.swift
//  InstaStream
//
//  Created by Rapid Dev on 05/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
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
