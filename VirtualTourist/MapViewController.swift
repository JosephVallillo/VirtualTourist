//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 5/4/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit
import MapKit
import CoreData

//MARK: - MapViewController: BaseViewController
class MapViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Actions
    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        if isEditMode {
            isEditMode = false
            editButton.title = "Edit"
        } else {
            isEditMode = true
            editButton.title = "Done"
        }
    }
    
    //MARK: Properties
    var selectedPin: Pin!
    var lastAddedPin: Pin? = nil
    var isEditMode = false
    var mapViewRegion: MapRegion?
    
    //MARK: Pins
    func addPin(gestureRecognizer: UIGestureRecognizer) {
        if isEditMode {
            return
        }
        
        let locationInMap = gestureRecognizer.locationInView(mapView)
        let coord: CLLocationCoordinate2D = mapView.convertPoint(locationInMap, toCoordinateFromView: mapView)
        
        switch gestureRecognizer.state {
        case .Began:
            lastAddedPin = Pin(coordinate: coord, context: self.sharedContext)
            mapView.addAnnotation(lastAddedPin!)
        case .Changed:
            lastAddedPin!.willChangeValueForKey("coordinate")
            lastAddedPin!.coordinate = coord
            lastAddedPin!.didChangeValueForKey("coordinate")
        case .Ended:
            getPhotosForPin(lastAddedPin!){ (success, errorString) in
                self.lastAddedPin!.isDownloading = false
                if success == false {
                    self.showAlert("An error occured", message: errorString!)
                    return
                }
            }
            CoreDataStackManager.sharedInstance().saveContext()
        default:
            return
        }
    }
    
    func deletePin(pin: Pin) {
        mapView.removeAnnotation(pin)
        sharedContext.deleteObject(pin)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addPinGesture = UILongPressGestureRecognizer(target: self, action: "addPin:")
        addPinGesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(addPinGesture)
        
        loadMapRegion()
        mapView.addAnnotations(fetchAllPins())
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifiers.LocationDetail {
            mapView.deselectAnnotation(selectedPin, animated: false)
            if let controller = segue.destinationViewController as? LocationDetailViewController {
                controller.pin = selectedPin
            }
        }
    }
}
