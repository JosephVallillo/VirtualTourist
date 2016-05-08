//
//  Photo.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 4/28/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Photo: NSManagedObject
class Photo: NSManagedObject {
    
    //MARK: Properties
    @NSManaged var photoURL: String
    @NSManaged var imagePath: String?
    @NSManaged var pin: Pin
    
    //MARK: Computer Properties
    var image: UIImage? {
        if imagePath != nil {
            let fileURL = getFileURL()
            return UIImage(contentsOfFile: fileURL.path!)
        }
        return nil
    }
    
    //MARK: Init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(photoURL: String, pin: Pin, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.photoURL = photoURL
        self.pin = pin
    }
    
    //MARK: Get File URL
    func getFileURL() -> NSURL {
        let fileName = (imagePath! as NSString).lastPathComponent
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)[0]
        let pathArray:[String] = [dirPath, fileName]
        let fileURL = NSURL.fileURLWithPathComponents(pathArray)
        return fileURL!
    }
    
    //MARK: Prepare for Deletion
    override func prepareForDeletion() {
        if (imagePath == nil) {
            return
        }
        let fileURL = getFileURL()
        if NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(fileURL.path!)
            } catch let error as NSError {
                print(error.userInfo)
            }
        }
    }
    
}
