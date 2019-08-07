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
//        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController{
//            present(pageViewController, animated: true ,completion: nil)
//        }
    }
    func checkConnection()  {
        
        self.reachability = Reachability.init()
        
        if reachability!.connection != .none{
            
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

extension ClinicTableVC {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            isFliteringToShow(filterItemCount: searchResults.count, of: clinics.count)
            return  searchResults.count
        }else{
            notFilteringToShow()
            return clinics.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClinicTableViewCell
        
        let clinic = isFiltering() ? searchResults[indexPath.row] : clinics[indexPath.row]
        cell.clinicNameLabel?.text = clinic.clinicName
        cell.containerView.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: cell.containerView.bounds)
        cell.containerView.layer.masksToBounds = false
        cell.containerView.layer.shadowColor = UIColor.gray.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: CGFloat(1), height: CGFloat(1))
        cell.containerView.layer.shadowOpacity = 1
        cell.containerView.layer.shadowPath = shadowPath2.cgPath
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        if searchController.isActive{
    //            return false
    //        }else{
    //
    //            return true
    //        }
    //    }
}
extension ClinicTableVC :UISearchResultsUpdating,UISearchBarDelegate  {
    
    // search bar
    func setUpSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = primaryColor
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "البحث عن عيادات ...."
        
        let placeHolderOffSet = UIOffset(horizontal: 90, vertical: 0)
        searchController.searchBar.setPositionAdjustment(placeHolderOffSet, for: .search)
        definesPresentationContext = true
        navigationController?.hidesBarsOnSwipe = true
        searchController.searchBar.scopeButtonTitles = ["الكل", "الدور الاول", "الدور الثاني", "الدور الثالث"]
        searchController.searchBar.delegate = self
        
        //        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough"){
        //            return
        //            }
        
        let refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(refresh), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = primaryColor
            return refreshControl
        }()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
            
        } else {
            tableView.tableHeaderView = searchController.searchBar
            
            // Fallback on earlier versions
        }
        
    }
    //search imp;ement delegate methods
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContent(for: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            filterContent(for: searchText,scope: scope)
            tableView.reloadData()
        }
    }
    
    func isFiltering()->Bool{
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContent(for searchText:String,scope:String = "الكل"){
        searchResults = clinics.filter({ (clinic) -> Bool in
            var intScope = 0
            switch scope {
            case "الدور الاول": intScope = 1
            case "الدور الثاني": intScope = 2
            case "الدور الثالث": intScope = 3
            default : intScope = 0
            }
            let isMatch = clinic.clinicName.lowercased().contains(searchText.lowercased()) ||  clinic.floorNum == Int(searchText)
            
            let doesTypeMatch = (scope == "الكل" ) || (clinic.floorNum == intScope)
            if searchBarIsEmpty(){
                return doesTypeMatch
            }else{
                return isMatch && doesTypeMatch
                
            }
            
        })
    }
    
    func isFliteringToShow(filterItemCount:Int , of totalItemCount:Int){
        if filterItemCount == 0 {
            searchFooter.text = "لا توجد عيادة بهذا الاسم اعد المحاوله مره اخري"
            showFooter()
        }else{
            searchFooter.text = "يوجد \(filterItemCount) من \(totalItemCount)"
            showFooter()
        }
    }
    func notFilteringToShow(){
        searchFooter.text = ""
        hideFooter()
    }
    func showFooter() {
        tableView.tableFooterView?.isHidden = false
        UIView.animate(withDuration: 0.7) {[unowned self] in
            self.searchFooter.alpha = 1.0
        }
    }
    func hideFooter() {
        UIView.animate(withDuration: 0.7) {[unowned self] in
            self.searchFooter.alpha = 0.0
        }
        tableView.tableFooterView?.isHidden = true
    }
}
