//
//  UdacityStudent.swift
//  On The Map
//
//  Created by Vishnu on 24/03/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

struct UdacityStudent {
    
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mediaURL : String?
    
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mediaURL = dictionary["mediaURL"] as? String
    }
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [UdacityStudent] {
        var students = [UdacityStudent]()
        
        for result in results {
            students.append(UdacityStudent(dictionary: result))
        }
        
        return students
    }
    
}