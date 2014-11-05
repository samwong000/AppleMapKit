//
//  Reminder.swift
//  AppleMapKit
//
//  Created by Sam Wong on 05/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var cordinatex: NSNumber
    @NSManaged var cordinatey: NSNumber
    @NSManaged var radius: NSNumber
    @NSManaged var name: String

}
