//
//  WalkthroughContentViewController.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 9/24/18.
//  Copyright © 2018 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var headingLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var contentImageView : UIImageView!
    @IBOutlet var pageController : UIPageControl!
    @IBOutlet var forwardButton:UIButton!
    
    @IBAction func nextButtonTapped(sender: Any){
        switch index {
        case 0...4:
            let pageViewController = parent as? WalkthroughPageViewController
            pageViewController?.forward(index: index)
        case 5:
            UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        headingLabel.text = heading
        contentTextView.text = content
        contentImageView.image = UIImage(named: imageFile)
        if index == 0{
        contentImageView.layer.cornerRadius = 15
        let shadowPath2 = UIBezierPath(rect: contentImageView.bounds)
        contentImageView.layer.masksToBounds = false
        contentImageView.layer.shadowColor = UIColor.black.cgColor
        contentImageView.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(2.0))
        contentImageView.layer.shadowOpacity = 1
            contentImageView.layer.shadowPath = shadowPath2.cgPath
            
        }
        pageController.currentPage = index
        switch index {
        case 0...4: forwardButton.setTitle("التالي", for: .normal)
        case 5 :  forwardButton.setTitle("تم", for: .normal)
        default:
            break
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
