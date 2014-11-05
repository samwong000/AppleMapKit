//
//  FirstViewController.swift
//  CoreLocationTabBar
//
//  Created by Sam Wong on 03/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set notification
        // selector "reminderAdded:", the : means there is a parameter in that funcation name
        // if "REMINDER_ADDED" is removed then the observer will receive all notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didAddReminder:", name: "DID_ADD_REMINDER", object: nil)
        
    
        self.locationManager.delegate = self
        

        
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressGesture:")
        self.mapView.addGestureRecognizer(longPress)
        self.mapView.delegate = self
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("authorized")
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            println("not determined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("restricted")
        case .Denied:
            println("denied")
        default:
            println("default")
        }
    }
    
    // to remove observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // return notification from AddReminderViewController class
    func didAddReminder(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let geoRegion = userInfo["region"] as CLCircularRegion
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)

        self.mapView.addOverlay(overlay)
    }
    
    func didLongPressGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(self.mapView)
            let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            // show touch point coordinate
            println("\(touchCoordinate.latitude) \(touchCoordinate.longitude)")
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Add Reminder"
            self.mapView.addAnnotation(annotation)
        }
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        
        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
        renderer.strokeColor = UIColor.grayColor()
        renderer.lineWidth = 0.5
        renderer.lineDashPattern = [1, 5]
        
        return renderer
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        
        // add button on the callout
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let addReminderVC = self.storyboard?.instantiateViewControllerWithIdentifier("ADDREMINDER_VC") as AddReminderViewController
        addReminderVC.locationManager = self.locationManager
        addReminderVC.selectedAnnotation = view.annotation
        
        self.presentViewController(addReminderVC, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            println("changed to authorized")
        default:
            println("default on authorization change")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("we got a location update")
        if let location = locations.last as? CLLocation {
            println(location.coordinate.latitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("enter region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("left region")
    }
    
    
}

