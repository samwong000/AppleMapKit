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
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressLabelBottomContraint: NSLayoutConstraint!
    
    @IBAction func setMapTypeSegmentPressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = MKMapType.Standard
        case 1:
            self.mapView.mapType = MKMapType.Satellite
        case 2:
            self.mapView.mapType = MKMapType.Hybrid
        default:
            mapView.mapType = mapView.mapType
        }
    }
    
    let locationManager = CLLocationManager()
    //var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location Reminder"
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        self.managedObjectContext = appDelegate.managedObjectContext
        
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
            println("viewDidLoad CLAuthorizationStatus.authorized")
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            println("viewDidLoad CLAuthorizationStatus.NotDetermined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("viewDidLoad CLAuthorizationStatus.Restricted")
        case .Denied:
            println("viewDidLoad CLAuthorizationStatus.Denied")
        default:
            println("viewDidLoad CLAuthorizationStatus.default")
        }
    }
    
    
    // to remove observer
    deinit {
        println("deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // return notification from AddReminderViewController class
    func didAddReminder(notification: NSNotification) {
        println("didAddReminder")
        
        let userInfo = notification.userInfo!
        let geoRegion = userInfo["region"] as CLCircularRegion
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)

        self.mapView.addOverlay(overlay)
        
        // add to table view
    }
    
    func didLongPressGesture(sender: UILongPressGestureRecognizer) {
        println("didLongPressGesture")
        
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
        println("mapView.rendererForOverlay")
        
        let renderer = MKCircleRenderer(overlay: overlay)
        
        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
        renderer.strokeColor = UIColor.grayColor()
        renderer.lineWidth = 0.5
        renderer.lineDashPattern = [1, 5]
        
        return renderer
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("mapView.viewForAnnotation")
        
        // show address label
//        let latitude = annotation.coordinate.latitude
//        let longitude = annotation.coordinate.longitude
//        var location = CLLocation(latitude: latitude, longitude: latitude)
//        let address = self.reverseGeocodeLocation(location)
//        
//        self.addressLabel.text = address
//        let labelheight = self.addressLabel.intrinsicContentSize().height
//        UIView.animateWithDuration(0.25, animations: { () -> Void in
//            self.addressLabelBottomContraint.constant = (labelheight - self.topLayoutGuide.length * 2)
//            self.view.layoutIfNeeded()
//        })
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        
        // add button on the callout
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("mapView.calloutAccessoryControlTapped")
        
        let addReminderVC = self.storyboard?.instantiateViewControllerWithIdentifier("ADDREMINDER_VC") as AddReminderViewController
        addReminderVC.locationManager = self.locationManager
        addReminderVC.selectedAnnotation = view.annotation
        addReminderVC.mapType = self.mapView.mapType
        
        self.presentViewController(addReminderVC, animated: true, completion: nil)

}

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            println("locationManager.didChangeAuthorizationStatus CLAuthorizationStatus.Authorized")
            locationManager.startUpdatingLocation()
            
        default:
            println("locationManager.didChangeAuthorizationStatus CLAuthorizationStatus.default")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("locationManager.didUpdateLocations")
        
        if let location = locations.last as? CLLocation {
//            println("Lat: \(location.coordinate.latitude), Long: \(location.coordinate.longitude)")
//            //Reverse Geocoding
//            self.reverseGeocodeLocation(location)
            
            locationManager.stopUpdatingLocation()
            //fetchNearbyPlaces(location.coordinate)
        }

    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("locationManager.didEnterRegion")
        
        // background notification
        if (UIApplication.sharedApplication().applicationState == UIApplicationState.Background) {
            var notification = UILocalNotification()
            notification.alertAction = "You have entered a monitored region."
            notification.alertBody = "Reminder."
            notification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("locationManager.didExitRegion")
    }
    
    
    func reverseGeocodeLocation(location: CLLocation) -> String? {
        var locationAddress: String?
        
        //Reverse Geocoding
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println(error)
            } else {
                let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                
                //Additional street-level information for the placemark.
                var subThoroughfare: String
                if (p.subThoroughfare != nil) {
                    subThoroughfare = p.subThoroughfare
                } else {
                    subThoroughfare = ""
                }
                
                locationAddress = "\(subThoroughfare) \(p.thoroughfare) \n \(p.subLocality) \n \(p.subAdministrativeArea) \n \(p.postalCode) \n \(p.country)"
                println("reverseGeocodeLocation address is \(locationAddress!)")
                
//                self.placemark = CLPlacemark(placemark: stuff[0] as CLPlacemark)
//                
//                self.addressLabel.text = String(format:"%@ %@\n%@ %@ %@\n%@",
//                    self.placemark.subThoroughfare ? self.placemark.subThoroughfare : "" ,
//                    self.placemark.thoroughfare ? self.placemark.thoroughfare : "",
//                    self.placemark.locality ? self.placemark.locality : "",
//                    self.placemark.postalCode ? self.placemark.postalCode : "",
//                    self.placemark.administrativeArea ? self.placemark.administrativeArea : "",
//                    self.placemark.country ? self.placemark.country : "")
            }
        })
        return locationAddress ?? nil
    }
    
    // address -> coordinate
    func forwardGeocode() {
        let geoCoder = CLGeocoder()
        let addressString = "6500 35th Ave NE USA"
        
        geoCoder.geocodeAddressString(addressString, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("forwardGeocode fail: \(error.localizedDescription)")
            } else {
                let pm = placemarks as [CLPlacemark]
                if pm.count > 0 {
                    let spanX = 0.00725
                    let spanY = 0.00725
                    //
                    //                    var region = MKCoordinateRegion(center: <#CLLocationCoordinate2D#>, span: <#MKCoordinateSpan#>))
                    //                    region.center.latitude = pm.location.coordinate.latitude
                    //                    region.center.longtitude = pm.location.coordinate.longitude
                    //                    region.span = MKCoordinateSpanMake(spanX, spanY)
                    
                    println(pm[0])
                    //                    self.mapView.setRegion(region: MKCoordinateRegion, animated: true)
                }
            }
        })
    }
    
}

