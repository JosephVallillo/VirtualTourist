//
//  LocationDetailViewController.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 5/4/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit
import MapKit
import CoreData

//MARK: - LocationDetailViewController: BaseViewController
class LocationDetailViewController: BaseViewController {

    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    //MARK: Action
    @IBAction func addNewCollection(sender: UIBarButtonItem) {
        loadNewCollectionSet()
    }
    
    //MARK: Properties
    var pin: Pin!
    
    var selectedIndexs = [NSIndexPath]()
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPath: [NSIndexPath]!
    
    //MARK: Fetched Results Controller
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    //MARK: View Controller Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        noImageLabel.hidden = true
        collectionView.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(pin)
        mapView.setCenterCoordinate(pin.coordinate, animated: true)
        
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let e as NSError{
            error = e
            print(error)
        }
        
        if error != nil || fetchedResultsController.fetchedObjects?.count == 0 {
            //fail gracefully - download new collection
            loadNewCollectionSet()
        }
        
        //disable new collection button if pin is downloading
        if pin.isDownloading {
            newCollectionButton.enabled = false
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pinFinishedDownload", name: pinFinishedDownloadingNotification, object: nil)
    }
    
    //MARK: Load Functions
    func loadNewCollectionSet() {
        for photo in fetchedResultsController.fetchedObjects as! [Photo] {
            sharedContext.deleteObject(photo)
        }
        CoreDataStackManager.sharedInstance().saveContext()
        
        self.newCollectionButton.enabled = false
        print(pin.photos.count)
        
        getPhotosForPin(pin) { (success, errorString) in
            self.pinFinishedDownloading()
            
            if success == false {
                self.showAlert("An error occured", message: errorString!)
                return
            }
        }
    }
    
    func pinFinishedDownloading() {
        if pin.isDownloading == true {
            return
        }
        self.newCollectionButton.enabled = true
        
        if let objects = self.fetchedResultsController.fetchedObjects {
            if objects.count == 0 {
                self.collectionView.hidden = true
                self.noImageLabel.hidden = false
                self.newCollectionButton.enabled = false
            }
        }
        
    }
    
    
}
