//
//  BaseViewController.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 5/2/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit
import CoreData

//MARK: - BaseViewController: UIViewController
class BaseViewController: UIViewController {

    //MARK: Core Data
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    //MARK: Show Alert
    func showAlert(title: String, message: String, buttonText: String = "Ok", shake: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .Default, handler: nil))
        if shake {
            self.shakeScreen()
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Shake Screen Animation
    func shakeScreen() {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(CATransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
            NSValue(CATransform3D: CATransform3DMakeTranslation(5, 0, 0))
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        view.layer.addAnimation(anim, forKey: nil)
    }
    
    //MARK: Get Photos For Pin
    let pinFinishedDownloadingNotification = "pinFinishedDownloadingNotification"
    
    func getPhotosForPin(pin: Pin, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if (pin.isDownloading) {
            return
        }
        pin.isDownloading = true
        FlickrClient.sharedInstance.getPhotosForPin(pin) { (success, errorString) in
            pin.isDownloading = false
            
            CoreDataStackManager.sharedInstance().saveContext()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: self.pinFinishedDownloadingNotification, object: self))
            completionHandler(success: success, errorString: errorString)
            
        }
    }
    
    
}
