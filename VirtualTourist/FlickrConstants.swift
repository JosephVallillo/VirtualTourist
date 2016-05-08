//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 4/27/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import Foundation

//MARK: - FlickrClient: FlickrConstants

extension FlickrClient {
    //MARK: Constants
    struct Constants {
        static let APIKey = "2db569c23aac5e508aa08bf35ddd02c6"
        static let BASE_URL = "https://api.flickr.com/services/rest/"
    }
    
    //MARK: Methods
    struct Methods {
        static let SEARCH = "flickr.photos.search"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let API_KEY          = "api_key"
        static let METHOD           = "method"
        static let SAFE_SEARCH      = "safe_search"
        static let EXTRAS           = "extras"
        static let FORMAT           = "format"
        static let NO_JSON_CALLBACK = "nojsoncallback"
        static let BBOX             = "bbox"
        static let PAGE             = "page"
        static let PER_PAGE         = "per_page"
        static let SORT             = "sort"
    }
    
    //MARK: Parameter Values
    struct ParameterValues {
        static let JSON_FORMAT  = "json"
        static let URL_M        = "url_m"
    }
    
    //MARK: BBox Parameters
    struct BBoxParameters {
        static let BOUNDING_BOX_HALF_WIDTH = 1.0
        static let BOUNDING_BOX_HALF_HEIGHT = 1.0
        static let LAT_MIN = -90.0
        static let LAT_MAX = 90.0
        static let LON_MIN = -180.0
        static let LON_MAX = 180.0
    }
}