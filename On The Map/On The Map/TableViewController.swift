//
//  TableViewController.swift
//  On The Map
//
//  Created by Vishnu on 23/03/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students: [UdacityStudent] = [UdacityStudent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        getData()
    }
    
    //Function to get student list
    func getData() {
        ParseClient.sharedInstance().getStudentLocations { (success, studentData, errorString) -> Void in
            if success {
                self.students = studentData!
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                }
            } else {
                //Alert view to inform the user getting student list failed
                var alert = UIAlertController(title: "Failed to get student list", message: "Fetching student list from server failed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Set the navigation bar title
        self.parentViewController!.navigationItem.title = "On The Map"
        
        //Create and set left button item
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshData")
        
        //Create and set right bar button item
        self.parentViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "pinButtonTouch")
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "StudentTableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell
        
        //Display name of the student in cell
        if let firstName = student.firstName {
            if let lastName = student.lastName {
                cell.textLabel!.text = firstName + " " + lastName
            } else {
                cell.textLabel!.text = firstName
            }
        }
        //Add pin image to cell
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Returns the count of students
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        //Opens the media url in Safari
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL!)!)
    }
    
    func pinButtonTouch() {
        //Present information posting vc when + button is touched
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as InformationPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func refreshData() {
        getData()
    }
}
