//
//  ExpertTableViewCell.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/23/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

class ExpertTableViewCell: UITableViewCell {

    @IBOutlet var expertNameLabel: UILabel!
    @IBOutlet var expertNationalityLabel: UILabel!
    @IBOutlet var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
