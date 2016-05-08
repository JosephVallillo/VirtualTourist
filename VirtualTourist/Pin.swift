//
//  Pin.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 4/27/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit
import MapKit
import CoreData

//MARK: - Pin: NSManagedObject, MKAnnotation
class Pin: NSManagedObject, MKAnnotation {
    
    //MARK: Properties
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var numPages: NSNumber?
    @NSManaged var photos: [Photo]
    
    var isDownloading = false
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
    
    //MARK: Init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
