//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Vishnu on 01/04/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
    }
    
    struct Methods {
        static let Session = "session"
        static let Users = "users"
    }
    
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let Session = "session"
        static let Error = "error"
        static let UserID = "key"
        static let SessionID = "id"
        static let UserData = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
}