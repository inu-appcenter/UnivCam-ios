//
//  DesignerTableViewCell.swift
//  UnivCam
//
//  Created by 조용문 on 2017. 8. 12..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class DesignerTableViewCell: UITableViewCell {
    @IBOutlet weak var left_label: UILabel!
    
    @IBOutlet weak var right_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
