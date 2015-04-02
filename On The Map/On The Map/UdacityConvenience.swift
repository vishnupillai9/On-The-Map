//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Vishnu on 01/04/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getSessionID(completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        //JSON, which contains the username and password
        let jsonBody : [String : AnyObject] = [
            UdacityClient.JSONBodyKeys.Udacity : [
                UdacityClient.JSONBodyKeys.Username : "\(username!)",
                UdacityClient.JSONBodyKeys.Password : "\(password!)"
            ]
        ]
        
        let task = taskForPOSTMethod(jsonBody) { (JSONResult, error) -> Void in
            if let error = error? {
                //Pass error message using completion handler. Ask user to check connection
                completionHandler(success: false, sessionID: nil, errorString: "Connection Error. Please check your connection and try again.")
            } else {
                if let account = JSONResult.valueForKey(JSONResponseKeys.Account) as? [String:AnyObject] {
                    if let userID = account[JSONResponseKeys.UserID] as? String {
                        //Store the user id of the user
                        self.userID = userID
                    }
                }
                if let session = JSONResult.valueForKey(JSONResponseKeys.Session) as? [String:AnyObject] {
                    if let sessionID = session[JSONResponseKeys.SessionID] as? String {
                        //Store the session id of the user
                        self.sessionID = sessionID
                        //Use completion handler to pass session id & update ui
                        completionHandler(success: true, sessionID: sessionID, errorString: nil)
                    }
                } else {
                    if let errorMessage = JSONResult.valueForKey(JSONResponseKeys.Error) as?  String {
                        //Pass error message using completion handler & update ui
                        completionHandler(success: false, sessionID: nil, errorString: errorMessage)
                    } else {
                        completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                    }
                }
            }
        }
    }
    
    func getPublicUserData(completionHandler: (success: Bool, firstName: String?, lastName: String?, errorString: String?) -> Void) {
        let task = taskForGETMethod { (JSONResult, error) -> Void in
            if let error = error? {
                //Pass error message using completion handler
                completionHandler(success: false, firstName: nil, lastName: nil, errorString: "Could not get user data")
            } else {
                if let userData = JSONResult.valueForKey(JSONResponseKeys.UserData) as? NSDictionary {
                    let firstName = userData[JSONResponseKeys.FirstName] as? String
                    let lastName = userData[JSONResponseKeys.LastName] as? String
                    //Pass first name & last name to vc using completion handler
                    completionHandler(success: true, firstName: firstName, lastName: lastName, errorString: nil)
                }
            }
        }
    }

}