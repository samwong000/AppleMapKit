//
//  CoreDataController.swift
//  AppleMapKit
//
//  Created by Sam Wong on 04/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
    
    var appDelegate : AppDelegate!
    var managedObjectContext : NSManagedObjectContext!
    
    class var sharedInstance : CoreDataController {
        struct Static {
            static let instance : CoreDataController = CoreDataController()
        }
        return Static.instance
    }
    
    init() {
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let managedObjectContext = self.appDelegate.managedObjectContext
    }

    
    
    // init core data variables
//    let fetchRequest = NSFetchRequest(entityName: "Reminders")
//    let sortDescriptor = NSSortDescriptor(key: "Date", ascending: true)
//    fetchRequest.sortDescriptors = [sortDescriptor]
//    fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
//    fetchedResultController.delegate = self
//    fetchedResultController.performFetch(nil)
    
    
//    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//    let managedObjectContext = self.appDelegate.managedObjectContext
//    
//    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
//
//    

//
//    fetchedResultController = getFetchedResultController()
//    fetchedResultController.delegate = self
//    fetchedResultController.performFetch(nil)
//    
//    
//    func getFetchedResultController() -> NSFetchedResultsController {
//        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
//        return fetchedResultController
//    }
//    
//    func taskFetchRequest() -> NSFetchRequest {
//        let fetchRequest = NSFetchRequest(entityName: "Tasks")
//        let sortDescriptor = NSSortDescriptor(key: "desc", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        return fetchRequest
//    }

}