//
//  SecondViewController.swift
//  CoreLocationTabBar
//
//  Created by Sam Wong on 03/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddReminderViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
//        let regionSet = self.locationManager.monitoredRegions
//        let regions = regionSet.allObjects
    }

    @IBAction func didPressAddReminderButton(sender: AnyObject) {
        var geoRegion = CLCircularRegion(center: self.selectedAnnotation.coordinate, radius: 5000.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        // insert a reminder into DB
        // the entity name must be the same one created in AppleMapKit.xcdatamodeld file
        var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.managedObjectContext) as Reminder
        newReminder.name = nameTextField.text
        
        var error: NSError?
        self.managedObjectContext.save(&error)
        
        if error != nil {
            println(error?.localizedDescription)
        } else {
            // send out notification
            NSNotificationCenter.defaultCenter().postNotificationName("DID_ADD_REMINDER", object: self, userInfo: ["region" : geoRegion])
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()         // Dispose of any resources that can be recreated.
    }
    


}


