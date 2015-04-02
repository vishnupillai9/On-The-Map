//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Vishnu on 24/03/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextViewDelegate {

    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var textLabels: [UILabel]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var firstName: String?
    var lastName: String?
    var lat: Double?
    var long: Double?
    
    var tapRecognizer: UITapGestureRecognizer?
    var defaultMediaText = "Enter a Link To Share Here"
    var defaultLocationText = "Enter Your Location Here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get public user data of the student, set first name and last name
        UdacityClient.sharedInstance().getPublicUserData { (success, firstName, lastName, errorString) -> Void in
            self.firstName = firstName!
            self.lastName = lastName!
        }
        
        submitButton.hidden = true
        mapView.hidden = true
        mediaTextView.hidden = true
        activityIndicator.hidden = true
        
        findOnTheMapButton.layer.cornerRadius = 5
        submitButton.layer.cornerRadius = 5
        
        textView.textContainerInset = UIEdgeInsetsMake(50, 20, 40, 20)
        textView.text = defaultLocationText
        mediaTextView.textContainerInset = UIEdgeInsetsMake(80, 20, 40, 20)
        mediaTextView.text = defaultMediaText
        
        //Tap Recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
        self.mapView.delegate = self
        self.textView.delegate = self
        self.mediaTextView.delegate = self
        
    }
    
    func addKeyboardDismissRecognizer() {
        //Add tap gesture recognizer to view
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        //Remove tap gesture recognizer from view
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        //Resign first responder on tap
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //Add tap recognizer when view appears
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //Remove tap recognizer when view disappears
        removeKeyboardDismissRecognizer()
    }
    
    func getCoordinatesFromAddressString(completion: (latitude: Double, longitude: Double) -> Void) {
        
        var lat: CLLocationDegrees = 0.0
        var long: CLLocationDegrees = 0.0
        
        var geoCoder = CLGeocoder()
        
        findOnTheMapButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        geoCoder.geocodeAddressString(self.textView.text, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("Geocode failed with error.")
                
                //Alert View for letting the user know geocoding failed
                var alert = UIAlertController(title: "Geocoding failed", message: "Geocoding address has failed.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.findOnTheMapButton.hidden = false
                
            } else if placemarks.count > 0 {
                //Get latitude and longitude from address string
                let placemark = placemarks[0] as CLPlacemark
                let coordinates = placemark.location.coordinate
                
                lat = coordinates.latitude
                long = coordinates.longitude
                println(self.textView.text)
                println("lat: \(lat), long: \(long)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.textView.hidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    for label in self.textLabels {
                        label.hidden = true
                    }
                    self.mediaTextView.hidden = false
                    self.mapView.hidden = false
                    self.submitButton.hidden = false
                    completion(latitude: lat, longitude: long)
                })
            }
        })
        
    }
    
    @IBAction func findOnTheMapButtonTouch(sender: UIButton) {
        getCoordinatesFromAddressString { (latitude, longitude) -> Void in
            //When find on the map button is touched, zoom into the location the user entered
            self.zoomInToLocation(latitude, longitude: longitude)
            self.lat = latitude
            self.long = longitude
        }
    }
    
    
    @IBAction func submitButtonTouch(sender: UIButton) {
        if let media = NSURL(string: mediaTextView.text) {
            ParseClient.sharedInstance().postStudentLocations(firstName!, lastName: lastName!, mapString: textView.text, mediaURL: mediaTextView.text, latitude: lat!, longitude: long!) { (success, responseMessage) -> Void in
                if success {
                    println(responseMessage!)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    //Alert view to let the user know post failed
                    var alert = UIAlertController(title: "Post Failed", message: "Failed to post your request to the server", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        } else {
            //Display alert view if URL provided is invalid
            var alert = UIAlertController(title: "Invalid URL", message: "Please enter a valid URL to continue.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Add pin and zoom into location
    func zoomInToLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(newAnnotation)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == defaultLocationText {
            textView.text = ""
        }
        if textView.text == defaultMediaText {
            textView.text = ""
        }
    }
}
