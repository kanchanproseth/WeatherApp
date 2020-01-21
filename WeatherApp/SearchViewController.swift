//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Kan Chanproseth on 12/30/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchController: UISearchController!
    var controllers: NSFetchedResultsController<City>!
    var city = [NSManagedObject]()
    var shouldShowSearchResults = false
    var filteredArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attemtfetch()
        configureSearchController()
        searchController.searchBar.isHidden = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controllers.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults == true {
            return filteredArray.count
        }else{
            let sections = controllers.sections
            let sectionInfo = sections?[section]
            return sectionInfo!.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MySearchCell = tableView.dequeueReusableCell(withIdentifier: "cellsearch", for: indexPath) as! searchCell
        if shouldShowSearchResults == true{
            MySearchCell.CityName.text = filteredArray[indexPath.row]
            print("reload filterdata")
        }else{
            configurecell(cell: MySearchCell, indexpath: indexPath as NSIndexPath)
        }
        return MySearchCell
    }
    func configurecell(cell:searchCell, indexpath: NSIndexPath){
        let accessCity = controllers.object(at: indexpath as IndexPath)
        cell.configureCell(city: accessCity)
    }
    
    func attemtfetch(){
        let fetchrequest : NSFetchRequest<City> = City.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchrequest.sortDescriptors = [dateSort]
        
        let resultcontroller = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultcontroller.delegate = self
        self.controllers = resultcontroller
        do{
            try controllers.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //Update Data == tableview.reload()---------------------------------------------------------------------------
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //CRUD == insert, Update, Delete, Move------------------------------------------------------------------------
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let updateCell = tableView.cellForRow(at: indexPath) as! searchCell
                configurecell(cell: updateCell, indexpath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }

    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.isHidden = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "ENTER CITY"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.tintColor = UIColor.orange
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.setValue("Done", forKey:"_cancelButtonText")
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    //Cancel Button action of SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("1")
        shouldShowSearchResults = false
        if (searchController.searchBar.text == ""){
            searchBar.showsCancelButton = false
        }else{
            let NewCity = City(context:context)
            if let newCityname = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces){
                print(newCityname)
                NewCity.cityname = newCityname
                let created = Date()
                NewCity.created = created
                AppDelegateAccess.saveContext()
                searchBar.showsCancelButton = false
            }
        }
        searchController.searchBar.isHidden = true
        tableView.tableHeaderView = nil
        tableView.reloadData()
        shouldShowSearchResults = false
        _ = navigationController?.popViewController(animated: true)
    }
    //when click Search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("2")
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        print("3")
        print("updateSearchResults")
        filteredArray.removeAll(keepingCapacity: false)
        arrFilter.removeAll(keepingCapacity: false)
        let request:NSFetchRequest<City>
        request = NSFetchRequest<City>(entityName: "City")
        
        do{
            let entities = try context.fetch(request)
            for item in entities{
                
                for key in item.entity.attributesByName.keys{
                    let value: Any? = item.value(forKey: key)
                    if key == "cityname" {
                        print("\(key) = \(value)")
                        arrFilter.append(value! as! String)
                        print(arrFilter)
                    }
                }
                let searchString = searchController.searchBar.text
                
                // Filter the data array and get only those countries that match the search text.
                filteredArray = arrFilter.filter({ (city) -> Bool in
                    let cityText: NSString = city as NSString
                    
                    return (cityText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                })
                print(arrFilter)
                if filteredArray == [] {
                    filteredArray = arrFilter
                }
                // Reload the tableview.
                tableView.reloadData()
                
            }
        }catch{
            
        }
    }


}
