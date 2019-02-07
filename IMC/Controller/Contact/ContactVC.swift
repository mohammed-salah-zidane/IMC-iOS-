//
//  ContactVC.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 2/6/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit
class ContactVC: UIViewController {
    @IBOutlet var sliderCollectionFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet var sliderCollectionView: UICollectionView!
    var images = ["contact1","imc1","imc2","imcb","imc3","imc4","imc5","imc6","imc7","imc8","imc9","imc10"]
    
    private var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        timer.fire()
      
    }

    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        
        
    }
    @objc func scrollAutomatically(_ timer1: Timer) {
        if let coll  = sliderCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < images.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
       // sliderCollectionView.stopScrolling()

        if timer.isValid {
            timer.invalidate()
        }
    }
}
extension ContactVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! SliderCollectionVCell
        
        cell.imageView.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: sliderCollectionView.frame.size.width, height: sliderCollectionView.frame.size.height)
    }
    
    
}
