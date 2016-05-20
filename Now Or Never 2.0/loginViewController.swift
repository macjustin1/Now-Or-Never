//
//  loginViewController.swift
//  Now Or Never
//
//  Created by Justin Mac on 5/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class loginViewController : UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    let loginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //super.viewDidAppear(true)
        
        self.loginButton.delegate = self
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.frame = CGRect(x: self.view.bounds.width/4, y: self.view.bounds.height-80, width: 200, height: 50)
        //loginButton.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height-50)
        //loginButton.delegate = self
        self.view.addSubview(loginButton)
        
    }

    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) { //if the person is logged in, present the view controller
            print("Logged in")
            //print("Name is: \(self.getFirstName())")
            //print("ID is: \(self.getID())")
            //print("Email is: \(self.getEmail())")
            self.getFirstName()
            //self.getEmail()
            self.loadViewController()
        }
        else {
            print("Not Logged in")
        }
    }
    
    /*func getEmail() -> String {
        let parameters = ["fields": "full_name, last_name, email"]
        var email : String = ""
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {
        (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            
            /*if let email_temp = result["email"] as? String {
                email = email_temp
                print(email_temp)
            }*/
            //print(result)
        }
        return email
    }*/
    
    
    func getFirstName() -> String { //return\s the name of the current logged profile
        let parameters = ["fields": "first_name, last_name"]
        var name : String = ""
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            
            if let firstName = result["first_name"] as? [String:AnyObject] {
                print("First name is \(firstName)")
                name = firstName["name"] as! String
            }
        }
        //print("Full name is: \(name)")
        return name
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil {
            print("Login Complete")
            self.loadViewController()
        }
        else {
            print(error.localizedDescription)
        }
    }
    
    func loadViewController() -> Void {
        self.performSegueWithIdentifier("showTabController", sender: self)
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
}