//
//  FlickrCell.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 5/1/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - FlickrCell: UICollectionViewCell
class FlickrCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
            
        if imageView.image == nil {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        }
    }
}
