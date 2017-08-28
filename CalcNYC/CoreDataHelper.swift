//
//  CoreDataHelper.swift
//  CalcNYC
//
//  Created by Justin Kim on 8/25/17.
//  Copyright © 2017 Justin Kim. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    //static methods will go here
    
    static func newItem() -> Item  {
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedContext) as! Item
        return item
    }
    
    static func delete(item: Item) {
        managedContext.delete(item)
        save()
    }
    
    static func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func retrieveItems() -> [Item] {
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.sorted(by: { (($0.creationTime!) as Date) > ($1.creationTime! as Date)})
            
            
            //            return results.sorted { (note: Note ,noteTwo: Note) -> Bool in
            //                let date1 = note.modificationTime! as Date
            //                let date2 = noteTwo.modificationTime! as Date
            //                return date1 > date2
            
            
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func newBudget() -> Budget  {
        let budget = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: managedContext) as! Budget
        return budget
    }


    
}

