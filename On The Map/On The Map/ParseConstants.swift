//
//  ParseConstants.swift
//  On The Map
//
//  Created by Vishnu on 01/04/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        static let ParseBaseURL: String = "https://api.parse.com/1/classes/StudentLocation"
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONResponseKeys {
        static let Results = "results"
        static let CreatedAt = "createdAt"
    }
    
    struct JSONBodyKeys {
        static let SessionID = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
}