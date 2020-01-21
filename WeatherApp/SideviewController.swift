//
//  SideviewController.swift
//  WeatherApp
//
//  Created by Kan Chanproseth on 12/20/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit
import SideMenuController
import CoreData

var arrFilter = [String]()
var arrCity = [String]()

class SideviewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //Delegate
    
    var controllers: NSFetchedResultsController<City>!
    var city = [NSManagedObject]()
    @IBOutlet weak var SegmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.isEditing = true
//        tableView.allowsSelectionDuringEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        attemtfetch()
        SegmentController.addTarget(self, action: #selector(sagementcall), for: .valueChanged)
        
    }
    @objc func sagementcall(_ mySegement : UISegmentedControl){
        var message = ""
        if SegmentController.selectedSegmentIndex == 0 {
            message = "C"
            sideMenuController?.performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        }else{
            message = "F"
            sideMenuController?.performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        }

      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivePush"), object: nil, userInfo: ["message" : message])
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
            let sections = controllers.sections
            let sectionInfo = sections?[section]
            return sectionInfo!.numberOfObjects
      
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Mycell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftSideViewCell
            configurecell(cell: Mycell, indexpath: indexPath as NSIndexPath)
        return Mycell
    }
    
    
    func configurecell(cell:LeftSideViewCell, indexpath: NSIndexPath){
        let accessCity = controllers.object(at: indexpath as IndexPath)
        cell.configureCell(city: accessCity)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controllers.fetchedObjects, objs.count > 0{
            let currenCity = objs[indexPath.row]
            print("\(currenCity)")
             arrCity.append(currenCity.cityname!)
            print("\(currenCity.cityname!)")
            sideMenuController?.performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        }
    }
   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Edit Tableviewcell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let accessCity = controllers.object(at: indexPath as IndexPath)
        var arr = [accessCity]
        //delete
        if editingStyle == .delete {
            // remove item from the model
            context.delete(arr[indexPath.row])
            arr.remove(at: indexPath.row)
            do {
                try context.save()
            } catch _ {}
        }
        
    }
    
    //getDataFromCoreData
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
                let updateCell = tableView.cellForRow(at: indexPath) as! LeftSideViewCell
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


    
    @IBAction func AddCity(_ sender: Any) {
        
        
    }
  


    
}

