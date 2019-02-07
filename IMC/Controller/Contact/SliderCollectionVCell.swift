//
//  SliderCollectionVCell.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 2/6/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

class SliderCollectionVCell: UICollectionViewCell {
    @IBOutlet weak var imageView:UIImageView!
    
    override func awakeFromNib() {
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
    }
}
