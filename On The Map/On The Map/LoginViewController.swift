//
//  LoginViewController.swift
//  On The Map
//
//  Created by Vishnu on 22/03/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer?
    
    //MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
        
        FBSDKLoginManager().logOut()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        removeKeyboardDismissRecognizer()
    }
    
    // MARK: - User Interface
    
    /// Configures the User Interface
    func configureUI() {
        // Set background to orange gradient
        view.backgroundColor = UIColor.clearColor()
        
        let colorTop = UIColor(red: 0.973, green: 0.518, blue: 0.055, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.957, green: 0.353, blue: 0.039, alpha: 1.0).CGColor
        
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        // Left padding the email text field
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        
        // Setting email placeholder text to white color
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // Left padding the password text field
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always

        // Setting password placeholder text to white color
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // Tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    // MARK: - Facebook Login
    
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
    
    /// Called when user logs out of Facebook
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) { }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        debugTextLabel.text = ""
        loginActivityIndicator.startAnimating()
       
        // Check if email/password field is empty
        if emailTextField.text.isEmpty || passwordTextField.text.isEmpty {
            debugTextLabel.text = "Email/Password Empty."
            loginActivityIndicator.stopAnimating()
        } else {
            // If not, proceed to get the session ID
            let jsonBody : [String : AnyObject] = [
                UdacityClient.JSONBodyKeys.Udacity : [
                    UdacityClient.JSONBodyKeys.Username : emailTextField.text,
                    UdacityClient.JSONBodyKeys.Password : passwordTextField.text
                ]
            ]
            
            UdacityClient.sharedInstance().getSessionID(jsonBody) { (success, sessionID, errorString) -> Void in
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.loginActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    /// Presents the Udacity sign up page using a web view
    @IBAction func signUpButtonTouch(sender: UIButton) {
        let signUpViewController = storyboard!.instantiateViewControllerWithIdentifier("SignUpNavigationController") as! UINavigationController
        
        presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    /// Completes the login
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Upon successful login, clear the debug label
            self.debugTextLabel.text = ""
            // Segue to MapTableVC
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    /// Displays error message
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
    }
    
    /// Adds tap gesture recognizer to view
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    /// Removes tap gesture recognizer from view
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    /// Resigns first responder on tap
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

