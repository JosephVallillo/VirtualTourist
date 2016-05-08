//
//  MapViewControllerMapDelegate.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 5/4/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import MapKit

//MARK: - MapViewController: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Pin {
            let identifier = Identifiers.Pin
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.animatesDrop = true
                view.draggable = false
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Pin selected")
        if let annotation = view.annotation as? Pin {
            selectedPin = annotation
            if !isEditMode {
                performSegueWithIdentifier(Identifiers.LocationDetail, sender: self)
            } else {
                let alert = UIAlertController(title: "Delete Pin", message: "Do you want to remove this Pin", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    self.selectedPin = nil
                    self.deletePin(annotation)
                }))
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Saving map Coordinates")
        saveMapRegion()
    }
}
