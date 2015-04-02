//
//  SignUpViewController.swift
//  On The Map
//
//  Created by Vishnu on 22/03/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    //Set the signup url
    let signUpURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")!
    
    override func viewDidLoad() {
        refresh()
        
        //Set the navigation title, left & right bar button item
        self.navigationItem.title = "Sign Up"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneButtonTouch")
        
    }
    
    func doneButtonTouch() {
        //Dismiss the vc if the user touches done button
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refresh() {
        let request = NSURLRequest(URL: signUpURL)
        //Load the request
        webView.loadRequest(request)
    }

}
