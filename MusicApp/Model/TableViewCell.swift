//
//  TableViewCell.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/03.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var videoTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
