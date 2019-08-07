//
//  DoctorTableViewCell.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/24/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var expandButton: UIButton!
    @IBOutlet var showDoctorReserveButton: UIButton!
    @IBOutlet var doctorSpecialityTextView: UITextView!
    @IBOutlet var doctorNameLabel: UILabel!
    @IBOutlet var dateCollectionView: UICollectionView!
    @IBOutlet var clinicNameLabel: UILabel!
    
    @IBOutlet var secondHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var showsDetails = false {
        didSet {
            secondHeightConstraint.priority = UILayoutPriority(rawValue:showsDetails ? 250 : 999)
        }
    }
    
}

extension DoctorTableViewCell{
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        dateCollectionView.delegate = dataSourceDelegate
        dateCollectionView.dataSource = dataSourceDelegate
        dateCollectionView.tag = row
        dateCollectionView.reloadData()
    }
    var collectionViewOffset: CGFloat {
        get {
            return dateCollectionView.contentOffset.x
        }
        
        set {
            dateCollectionView.contentOffset.x = newValue
        }
    }
    
}
