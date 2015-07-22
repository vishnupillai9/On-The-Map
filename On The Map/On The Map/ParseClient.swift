//
//  ParseClient.swift
//  On The Map
//
//  Created by Vishnu on 01/04/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // 1. Set parameters
        let limit = 100
        
        // 2. Build URL
        let urlString = Constants.ParseBaseURL
        let url = NSURL(string: urlString)!
        
        // 3. Configure request
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // 4. Make request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                let newError = CommonClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                // 5/6. Parse & use the data
                CommonClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethod(jsonBody: [String:AnyObject], completionHandler: (result:AnyObject!, error:NSError?) -> Void) -> NSURLSessionDataTask {
        // 1. No parameters
        
        // 2. Build URL
        let urlString = Constants.ParseBaseURL
        let url = NSURL(string: urlString)!
        
        // 3. Configure request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: nil)
        
        // 4. Make request
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                let newError = CommonClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                // 5/6. Parse and use the data
                CommonClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
            
        }
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}