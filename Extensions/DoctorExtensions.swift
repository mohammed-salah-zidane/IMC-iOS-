//
//  DoctorExtensions.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 2/5/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import Foundation
import UIKit


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
            return 210;
            
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
            self.performSegue(withIdentifier: "showDoctorReserve", sender: self)
            
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
    
    @objc func expandingWithParam(_sender: UIButton){
        
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
