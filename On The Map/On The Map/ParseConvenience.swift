//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Vishnu on 02/04/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler: (success: Bool, studentData: [UdacityStudent]?, errorString: String?) -> Void) {
        
        let task = taskForGETMethod { (JSONResult, error) -> Void in
            if let error = error? {
                //Pass error message using completion handler
                completionHandler(success: false, studentData: nil, errorString: "Could not get student locations")
            } else {
                if let results = JSONResult.valueForKey(JSONResponseKeys.Results) as? [[String:AnyObject]] {
                    let students = UdacityStudent.studentsFromResults(results)
                    //Pass student data to vc using completion handler
                    completionHandler(success: true, studentData: students, errorString: nil)
                } else {
                    //Pass error message using completion handler
                    completionHandler(success: false, studentData: nil, errorString: "Could not get student locations")
                }
            }
        }
    }
    
    func postStudentLocations(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, responseMessage: String?) -> Void) {
        
        //JSON, which contains data for posting student data
        let jsonBody: [String: AnyObject] = [
            JSONBodyKeys.SessionID: UdacityClient.sharedInstance().sessionID!,
            JSONBodyKeys.FirstName: firstName,
            JSONBodyKeys.LastName: lastName,
            JSONBodyKeys.MapString: mapString,
            JSONBodyKeys.MediaURL: mediaURL,
            JSONBodyKeys.Latitude: latitude,
            JSONBodyKeys.Longitude: longitude
        ]
        
        let task = taskForPOSTMethod(jsonBody) { (JSONResult, error) -> Void in
            if let error = error? {
                //Pass error message using completion handler
                completionHandler(success: false, responseMessage: "Could not post location")
            } else {
                if let response = JSONResult.valueForKey(JSONResponseKeys.CreatedAt) as? String {
                    //Pass response message to vc using completion handler
                    completionHandler(success: true, responseMessage: response)
                } else {
                    //Pass error message using completion handler
                    completionHandler(success: false, responseMessage: "Could not post location")
                }
            }
        }
    }
    
}