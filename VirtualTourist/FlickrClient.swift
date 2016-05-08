//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Joseph Vallillo on 4/27/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import Foundation

//MARK: - FlickrClient: NSObject
class FlickrClient: NSObject {
    //MARK: Properties
    var session: NSURLSession
    
    //MARK: Shared Instance
    static let sharedInstance = FlickrClient()
    
    //MARK: Init
    private override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //MARK: GET Methods
    func taskForGETMethod(url: String?, parameters: [String : AnyObject]?, parseJSON: Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = (url != nil) ? url : Constants.BASE_URL
        if parameters != nil {
            var mutableParameters = parameters
            mutableParameters![ParameterKeys.API_KEY] = Constants.APIKey
            urlString = urlString! + FlickrClient.escapedParameters(parameters!)
        }
        
        let url = NSURL(string: urlString!)!
        let request = NSURLRequest(URL: url)
        
        /*Make the request*/
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /*GUARD: Was there an error*/
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: NSError(domain: "getTask", code: 2, userInfo: nil))
                return
            }
            
            /*GUARD: Did we get a successful 2XX response*/
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var errorCode = 0
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    errorCode = response.statusCode
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                dispatch_async(dispatch_get_main_queue()){
                    completionHandler(result: nil, error: NSError(domain: "getTask", code: errorCode, userInfo: nil))
                }
                return
            }
            
            /*GUARD: Was there any data returned*/
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error: NSError(domain: "getTask", code: 3, userInfo: nil))
                return
            }
            
            /*Parse the data use the data*/
            if parseJSON {
                FlickrClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            } else {
                completionHandler(result: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    //MARK: Helper Methods
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
}
