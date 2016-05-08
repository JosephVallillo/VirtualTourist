//
//  MapViewControllerCoreData.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 5/4/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import CoreData

//MARK: - MapViewController
extension MapViewController {
    
    //MARK: Fetch All Pins
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        var pins: [Pin] = []
        do {
            let results = try sharedContext.executeFetchRequest(fetchRequest)
            pins = results as! [Pin]
        } catch let error as NSError {
            showAlert("load data error", message: "Something went wrong trying to load existing data")
            print("error in fetchAllPins: \(error.localizedDescription)")
        }
        return pins
    }
    
    //MARK: Save Map Region
    func saveMapRegion() {
        if mapViewRegion == nil {
            mapViewRegion = MapRegion(region: mapView.region, context: self.sharedContext)
        } else {
            mapViewRegion!.region = mapView.region
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    //MARK: Load Map Region
    func loadMapRegion() {
        let fetchRequest = NSFetchRequest(entityName: "MapRegion")
        var regions: [MapRegion] = []
        do {
            let results = try sharedContext.executeFetchRequest(fetchRequest)
            regions = results as! [MapRegion]
        } catch let error as NSError {
            print("error in loadMapRegion: \(error.localizedDescription)")
        }
        if regions.count > 0 {
            mapViewRegion = regions[0]
            mapView.region = mapViewRegion!.region
        } else {
            mapViewRegion = MapRegion(region: mapView.region, context: self.sharedContext)
        }
    }
}