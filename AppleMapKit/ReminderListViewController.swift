//
//  ViewController.swift
//  AppleMapKit
//
//  Created by Sam Wong on 04/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import UIKit
import CoreData

class ReminderListViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController!
    
//    var reminder = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
        
        // fetch data from DB
        var fetchRequest = NSFetchRequest(entityName: "Reminder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "ReminderCache")
        
        self.fetchedResultsController.delegate = self
        self.tableView.dataSource = self
        
        var error: NSError?
        if self.fetchedResultsController.performFetch(&error) {
            println("ReminderListViewController.viewDidLoad Error : \(error?.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
        let reminder = self.fetchedResultsController.fetchedObjects?[indexPath.row] as Reminder
        
        cell.textLabel.text = reminder.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func didGetCloudChanges(notification: NSNotification) {
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    // MARK : - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
}

