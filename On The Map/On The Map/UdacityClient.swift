//
//  UdacityClient.swift
//  On The Map
//
//  Created by Vishnu on 01/04/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var session: NSURLSession

    var sessionID: String? = nil
    var userID: String? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForPOSTMethod(jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // 1. No parameters
        
        // 2. Build URL
        let urlString = Constants.UdacityBaseURL + Methods.Session
        let url = NSURL(string: urlString)!
        
        // 3. Configure request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: nil)
        
        // 4. Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            // 5/6. Parse and use the data
            if let error = downloadError {
                let newError = CommonClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                CommonClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    func taskForGETMethod(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // 1. No parameters
        
        // 2. Build url
        let urlString = Constants.UdacityBaseURL + Methods.Users + "/\(userID!)"
        let url = NSURL(string: urlString)!
        
        // 3. Configure request
        let request = NSMutableURLRequest(URL: url)
        
        // 4. Make the request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                let newError = CommonClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                // 5/6. Parse and use the data
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                CommonClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}