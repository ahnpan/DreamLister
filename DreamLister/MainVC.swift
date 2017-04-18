//
//  MainVC.swift
//  DreamLister
//
//  Created by Ruby Vega on 09/04/2017.
//  Copyright © 2017 Ruby Vega. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if let sections = controller.sections{
            
            let sectionInfo = sections[section]
            
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
    
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections{
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if(segment.selectedSegmentIndex == 0){
            
            fetchRequest.sortDescriptors = [dateSort]
            
        }else if(segment.selectedSegmentIndex == 1){
            
            fetchRequest.sortDescriptors = [priceSort]
            
        }else if(segment.selectedSegmentIndex == 2){
            
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do{
            
            try controller.performFetch()
            
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
    
        attemptFetch()
        tableView.reloadData()
    
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
        }
        
    }
    
    func generateTestData(){
    
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 150000
        item.details = "Hopefully it'd be better than 2016."
        
        let item2 = Item(context: context)
        item2.title = "Bose"
        item2.price = 1500
        item2.details = "New headphones yeah."
        
        let item3 = Item(context: context)
        item3.title = "Car!"
        item3.price = 150000000
        item3.details = "So pretty car! T_T"
        
        ad.saveContext()
    }
}
