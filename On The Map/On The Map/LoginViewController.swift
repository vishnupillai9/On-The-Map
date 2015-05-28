//
//  LoginViewController.swift
//  On The Map
//
//  Created by Vishnu on 22/03/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    var tapRecognizer: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
        
        FBSDKLoginManager().logOut()
    }

    func configureUI() {
        
        //Set background to orange gradient
        self.view.backgroundColor = UIColor.clearColor()
        
        let colorTop = UIColor(red: 0.973, green: 0.518, blue: 0.055, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.957, green: 0.353, blue: 0.039, alpha: 1.0).CGColor
        
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        //Left padding the email text field
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        
        //Setting email placeholder text to white color
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //Left padding the password text field
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always

        //Setting password placeholder text to white color
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //Tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
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
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        //Check if email/password field is empty
        if emailTextField.text.isEmpty || passwordTextField.text.isEmpty {
            self.debugTextLabel.text = "Email/Password Empty."
        } else {
            //If not, proceed to get the session ID
            let jsonBody : [String : AnyObject] = [
                UdacityClient.JSONBodyKeys.Udacity : [
                    UdacityClient.JSONBodyKeys.Username : "\(self.emailTextField.text)",
                    UdacityClient.JSONBodyKeys.Password : "\(self.passwordTextField.text)"
                ]
            ]
            
            UdacityClient.sharedInstance().getSessionID(jsonBody) { (success, sessionID, errorString) -> Void in
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //Upon successful login, clear the debug label
            self.debugTextLabel.text = ""
            //Segue to MapTableVC
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    @IBAction func signUpButtonTouch(sender: UIButton) {
        //If sign up button is touched, present the udacity sign up page using a web view
        
        let signUpViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SignUpNavigationController") as! UINavigationController
        
            self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            println("Facebook login error")
        } else if result.isCancelled {
            println("Facebook login error (Cancelled)")
        } else {
            let jsonBody = ["facebook_mobile": ["access_token": "\(FBSDKAccessToken.currentAccessToken().tokenString)"]]
            UdacityClient.sharedInstance().getSessionID(jsonBody, completionHandler: { (success, sessionID, errorString) -> Void in
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            })
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out")
    }
    
}

