import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ExpertTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            isFliteringToShow(filterItemCount: searchResults.count, of: experts.count)
            return  searchResults.count
        }else{
            notFilteringToShow()
            return experts.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExpertTableViewCell
        
        let expert = isFiltering() ? searchResults[indexPath.row] : experts[indexPath.row]
        
        cell.expertNameLabel?.text = expert.expertName
        
        cell.expertNationalityLabel?.text = expert.expertNationality
        cell.containerView.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: cell.containerView.bounds)
        cell.containerView.layer.masksToBounds = false
        cell.containerView.layer.shadowColor = UIColor.gray.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        cell.containerView.layer.shadowOpacity = 1
        cell.containerView.layer.shadowPath = shadowPath2.cgPath
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive{
            return false
        }else{
            
            return true
        }
    }
}
extension ExpertTableViewController:UISearchResultsUpdating,UISearchBarDelegate {
    func setUpSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "البحث عن خبراء ...."
        definesPresentationContext = true
        let placeHolderOffSet = UIOffset(horizontal: 90, vertical: 0)
        searchController.searchBar.tintColor = primaryColor
        searchController.searchBar.setPositionAdjustment(placeHolderOffSet, for: .search)
        searchController.searchBar.scopeButtonTitles = ["الكل", "امريكي", "انجليزي", "فرنسي"]
        searchController.searchBar.delegate = self
        
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
    //search
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
    func filterContent(for searchText:String,scope:String = "الكل")
    {
        searchResults = experts.filter(
            { (expert) -> Bool in
                
                let isMatch = expert.expertName.lowercased().contains(searchText.lowercased()) ||  expert.expertNationality.lowercased().contains(searchText.lowercased())
                
                let doesTypeMatch = (scope == "الكل" ) || (expert.expertNationality.lowercased() == scope.lowercased())
                if searchBarIsEmpty()
                {
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


