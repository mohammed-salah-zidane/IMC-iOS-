//
//  DoctorViewController.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/29/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit
class DoctorViewController: UIViewController {


    var clinicId = 0
    var clinicName = ""
    @IBOutlet var tableView: UITableView!
    var selectedIndex = -1
    
    var doctors = [Doctor]()
    var storedOffsets = [Int: CGFloat]()
    var count = 0

    var index = 0
    var colectionViewTag = [Int]()
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    var  reachability :Reachability?
     @IBOutlet var connectivityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(fromGesture:)))
        tableView.addGestureRecognizer(gesture)
        self.navigationItem.backBarButtonItem?.title = ""
        
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
        definesPresentationContext = true
       // navigationController?.hidesBarsOnSwipe = false
        tableView.tableHeaderView?.isHidden = true
        connectivityLabel.isHidden = false
        checkConnection()
    
    
    }
    func checkConnection()  {
        
        self.reachability = Reachability.init()
        
        if reachability!.connection != .none{
            
            tableView.tableHeaderView?.isHidden = false
            connectivityLabel.text = "connected"
            connectivityLabel.isHidden = false
            connectivityLabel.textColor = .green
            UIView.animate(withDuration: 0.7) {[unowned self] in
                self.connectivityLabel.alpha = 0.0
            }
            tableView.tableHeaderView?.isHidden = true
        }else {
            tableView.tableHeaderView?.isHidden = false
            connectivityLabel.text = "no internet connection"
            connectivityLabel.textColor = .red
            UIView.animate(withDuration: 0.7) {[unowned self] in
                self.connectivityLabel.alpha = 1   }
        }
    }
    @objc func dismiss(fromGesture gesture: UISwipeGestureRecognizer) {
       
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        setLoadingScreen()
        API.fetchDoctors(id: clinicId) { (error, success, doctors) in
           
            
            if success {
                self.removeLoadingScreen()
                self.doctors = doctors
                self.tableView.reloadData()
            
            }
        }
        
    }
    private func setLoadingScreen() {
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = primaryColor
        loadingLabel.textAlignment = .center
        loadingLabel.text = "تحميل ......"
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.color = primaryColor
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
}

extension DoctorViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? DoctorTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? DoctorTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row) {
            return 225;
            
        } else {
            
            return 60;
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.middle )
        self.tableView.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        index = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DoctorTableViewCell
        
        index  = indexPath.row
        cell.doctorNameLabel.text = doctors[indexPath.row].name
        cell.clinicNameLabel.text = clinicName
        cell.doctorSpecialityTextView.text = doctors[indexPath.row].degree
        
        let shadowPath2 = UIBezierPath(rect: cell.showDoctorReserveButton.bounds)
        cell.showDoctorReserveButton.layer.masksToBounds = false
        cell.showDoctorReserveButton.layer.shadowColor = UIColor(red: 14.0/255.0, green:175.0/255.0, blue: 127.0/255.0, alpha: 1.0).cgColor
        cell.showDoctorReserveButton.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        cell.showDoctorReserveButton.layer.shadowOpacity = 0.3
        cell.showDoctorReserveButton.layer.shadowPath = shadowPath2.cgPath
        
        
        let shadowPath3 = UIBezierPath(rect: cell.containerView.bounds)
        cell.containerView.layer.masksToBounds = false
        cell.containerView.layer.shadowColor =  UIColor(red: 14.0/255.0, green:175.0/255.0, blue: 127.0/255.0, alpha: 1.0).cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: CGFloat(0.2), height: CGFloat(0.2))
        cell.containerView.layer.shadowOpacity = 1
        cell.containerView.layer.shadowPath = shadowPath3.cgPath
        
        cell.showDoctorReserveButton.tag = indexPath.row
        cell.showDoctorReserveButton.addTarget(self, action: #selector(actionWithParam), for: .touchUpInside)
        
        cell.expandButton.tag = indexPath.row
        cell.expandButton.addTarget(self, action: #selector(expandingWithParam), for: .touchUpInside)
        
        return cell
    }
    
    @objc func actionWithParam(_sender: UIButton){
        let alert = UIAlertController(title: "تنبيه", message: "سيتم الحجز في خلال ٧٢ ساعة من الان", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "استمرار", style: .default) { (action :UIAlertAction!) in
            
            segueDoctorId = self.doctors[self.index].doctorId
            segueExpertId = 0
            let reserveVC = self.storyboard?.instantiateViewController(withIdentifier: "reserveStoryboard") as! ReserveTableViewController
            self.navigationController?.pushViewController(reserveVC, animated: true)
            //self.performSegue(withIdentifier: "showDoctorReserve", sender: self)
            
            //                if let indexpath = self.tableView.indexPathForSelectedRow {
            //                    self.performSegue(withIdentifier: "showDoctorReserve", sender: self)
            //                }
            
        }
        let cancelAction = UIAlertAction(title: "إلغاء", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert ,animated: true,completion: nil)
        return
        
    }
    
    @objc func expandingWithParam(_ sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
     
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.middle )
        self.tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        if segue.identifier == "showDoctorReserve" {
        //            if let indexpath = tableView.indexPathForSelectedRow {
        //                 segueDoctorId = self.doctors[indexpath.row].doctorId
        //            }
        //        }
    }
    
}

extension DoctorViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return doctors[index].days.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Check", for: indexPath) as! DatesCollectionViewCell
        
        
        cell.dayLabel.text = doctors[index].days[indexPath.row]
        cell.hoursLabel.text = doctors[index].hours[indexPath.row]
        
        let shadowPath3 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        cell.layer.shadowOpacity = 1
        cell.layer.shadowPath = shadowPath3.cgPath
        collectionView.tag = 0
        return cell
    }
    
    
}
