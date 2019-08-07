//
//  ExpertDetailsViewController.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/27/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

class ExpertDetailsViewController: UIViewController {

    @IBOutlet weak var expertSpecialityLabel: UITextView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet weak var detailsSpecialtyLabel: UILabel!
    @IBOutlet var reserveButton: UIButton!
    @IBOutlet var generalSpecialityLabel: UILabel!
    @IBOutlet var expertNameLabel: UILabel!
    
    @IBOutlet var expertSpecializtionTextView: UITextView!
    @IBOutlet var expertPeriodLabel: UILabel!
    @IBOutlet var expertNationalityLabel: UILabel!
    
    var expert : Expert!
    @IBAction func showExpertReserveForm(_ sender: Any) {
        let alert = UIAlertController(title: "تنبيه", message: "سيتم الحجز في خلال ٧٢ ساعة من الان", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "استمرار", style: .default) { (action :UIAlertAction!) in
            
            segueExpertId = self.expert.expertId
            segueDoctorId = 0
            let reserveVC = self.storyboard?.instantiateViewController(withIdentifier: "reserveStoryboard") as! ReserveTableViewController
            self.navigationController?.pushViewController(reserveVC, animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "إلغاء", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert ,animated: true,completion: nil)
        return
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: false )
    //navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //expertSpecializtionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(fromGesture:)))
        view.addGestureRecognizer(gesture)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
       // backgroundImageView.addSubview(blurEffectView)
        
        let scaleTransform  = CGAffineTransform.init(scaleX: 0 , y : 0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform 
        
        expertNameLabel.text = expert.expertName
        expertNationalityLabel.text = expert.expertNationality
        generalSpecialityLabel.text = expert.generalSpeciality
        detailsSpecialtyLabel.text = expert.speciality
      //  print(expertSpecializtionTextView.text)
        print(expert.speciality)

        expertPeriodLabel.text = "من \(expert.from) الي \(expert.to)"
 
        let date = Date()
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        let currentDate = dateFormatter.string(from: date)
        
        let till = dateFormatter.date(from: expert.to)!

        let now = dateFormatter.date(from: currentDate)!


        if now > till {
            print("expired")
            reserveButton.isEnabled = false
            reserveButton.alpha = 0
            let alert = UIAlertController(title: "تنبيه", message: "عفوا لا يمكنك الحجز , هذا الخبير غير موجود حاليا بالمستشفي ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert ,animated: true,completion: nil)
            return
        }
    
        
        
        /*
        let date = Date()
        if toDate! < date {
            print("available")
        }*/
    }
    
    @objc func dismiss(fromGesture gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.5, delay: 0 , usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4
            , options: .curveEaseInOut  , animations: {
                self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func didReservationButtonPressed(_ sender: Any) {
        
        segueDoctorId = 0
        segueExpertId = expert.expertId
        let reserveVC = self.storyboard?.instantiateViewController(withIdentifier: "reserveStoryboard") as! ReserveTableViewController
        self.navigationController?.pushViewController(reserveVC, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
