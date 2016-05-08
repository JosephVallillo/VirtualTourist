//
//  MapRegion.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 4/28/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import CoreData
import MapKit

//MARK: - MapRegion: NSManagedObject
class MapRegion: NSManagedObject {
    //MARK: Properties
    @NSManaged var centerLatitude: Double
    @NSManaged var centerLongitude: Double
    @NSManaged var spanLatitude: Double
    @NSManaged var spanLongitude: Double
    
    //MARK: Computed Properties
    var region: MKCoordinateRegion {
        set {
            centerLatitude = newValue.center.latitude
            centerLongitude = newValue.center.longitude
            spanLatitude = newValue.span.latitudeDelta
            spanLongitude = newValue.span.longitudeDelta
        }
        get {
            let center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
            let span = MKCoordinateSpanMake(spanLatitude, spanLongitude)
            return MKCoordinateRegionMake(center, span)
        }
    }
    
    //MARK: Init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(region: MKCoordinateRegion, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("MapRegion", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.region = region
    }
}
