//
//  ClinicTableViewController.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/22/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClinicTableVC: UITableViewController{
  
    @IBOutlet var connectivityLabel: UILabel!
    @IBOutlet var searchFooter: UILabel!
     var searchController : UISearchController!
     var clinics : [Clinic] = []
     var searchResults : [Clinic] = []
     let loadingView = UIView()
     let spinner = UIActivityIndicatorView()
     let loadingLabel = UILabel()
     var  reachability :Reachability?
    override func viewWillAppear(_ animated: Bool) {
        self.setLoadingScreen()
        API.fetchClinic { (error, success, clinics : [Clinic]) in
           
            if success {
                self.removeLoadingScreen()
                self.clinics = clinics
                self.tableView.reloadData()
            }else{
                print("error")
            }
        }
        
        
        hideFooter()
        tableView.tableFooterView?.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideFooter()
        tableView.tableHeaderView?.isHidden = true
        connectivityLabel.isHidden = false
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        //navigationController?.hidesBarsOnSwipe = true
        setUpSearchBar()
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

    @objc func refresh(_ refreshControl: UIRefreshControl)
    {
        if reachability!.connection != .none{
           API.fetchClinic { (error, success, clinics : [Clinic]) in
            if success {
                self.clinics = clinics
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }else{
                print("error")
            }
            
           }
        }else{
            if #available(iOS 10.0, *) {
                tableView.refreshControl?.endRefreshing()
            } else {
                // Fallback on earlier versions
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDoctors" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! DoctorViewController
                destinationViewController.clinicId = clinics[indexpath.row].clinicId
                destinationViewController.clinicName = clinics[indexpath.row].clinicName

                //isFiltering() ? searchResults[indexpath.row]:
            }
        }
    }
    
    
}
