//
//  SecondViewController.swift
//  CoreLocationTabBar
//
//  Created by Sam Wong on 03/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import UIKit
import MapKit

class AddReminderViewController: UIViewController {

    @IBAction func didPressAddReminderButton(sender: AnyObject) {
        
        //        println("\(selectedAnnotation.coordinate.longitude) \(selectedAnnotation.coordinate.latitude)")
        
        
        var geoRegion = CLCircularRegion(center: self.selectedAnnotation.coordinate, radius: 5000.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        NSNotificationCenter.defaultCenter().postNotificationName("DID_ADD_REMINDER", object: self, userInfo: ["region" : geoRegion])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regionSet = self.locationManager.monitoredRegions
        let regions = regionSet.allObjects
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reverseGeocode(location: CLLocation) {
        var geoCoder = CLGeocoder()

        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
            { (placemarks, error) in
                if (error != nil) {
                    println("reverse geodcode fail: \(error.localizedDescription)")
                } else {
                    let pm = placemarks as [CLPlacemark]
                    if pm.count > 0 {
                        println(pm[0])
                        //self.showAddPinViewController(placemarks[0] as CLPlacemark)
                    }
                }
        })
    }
    
//    func reverseGeocode2(location: CLLocation) {
//        var geoCoder = CLGeocoder()
//        
//        geoCoder.reverseGeocodeLocation(newLocation, completionHandler: {(stuff, error)->Void in
//            
//            if error {
//                println("reverse geodcode fail: \(error.localizedDescription)")
//                return
//            }
//            
//            if stuff.count > 0 {
//                self.placemark = CLPlacemark(placemark: stuff[0] as CLPlacemark)
//                
//                self.addressLabel.text = String(format:"%@ %@\n%@ %@ %@\n%@",
//                    self.placemark.subThoroughfare ? self.placemark.subThoroughfare : "" ,
//                    self.placemark.thoroughfare ? self.placemark.thoroughfare : "",
//                    self.placemark.locality ? self.placemark.locality : "",
//                    self.placemark.postalCode ? self.placemark.postalCode : "",
//                    self.placemark.administrativeArea ? self.placemark.administrativeArea : "",
//                    self.placemark.country ? self.placemark.country : "")
//            }
//            else {
//                println("No Placemarks!")
//                return
//            }
//            
//        })
//    }
    
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


