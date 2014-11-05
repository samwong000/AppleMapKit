//
//  NetworkController.swift
//  AppleMapKit
//
//  Created by Sam Wong on 04/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import Foundation

class NetworkController {

    class var sharedInstance : NetworkController {
        struct Static {
            static let instance : NetworkController = NetworkController()
        }
        return Static.instance
    }
    
    
}