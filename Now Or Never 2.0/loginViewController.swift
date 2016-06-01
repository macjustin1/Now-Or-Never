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
        loginButton.frame = CGRect(x: self.view.bounds.width/4, y: self.view.bounds.height-120, width: 200, height: 50)
        //loginButton.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height-50)
        //loginButton.delegate = self
        self.view.addSubview(loginButton)
        
    }

    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) { //if the person is logged in, present the view controller
            print("Logged in")
            //print("ID is: \(self.getID())")
            //print("Email is: \(self.getEmail())")
            //self.getFirstName()
            
            //self.getEmail()
            self.loadViewController()
        }
        else {
            print("Not Logged in")
        }
    }
    
    func getEmail(completion:(result:String) -> Void) {
        let parameters = ["fields": "email"]
        var email : String = ""
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {
        (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            email = result.valueForKey("email") as! String
            completion(result:email)
        }
    }
    
    //uses a completion handler to make sure it stores the name before continuing other actions
    func getFullName(completion:(result:String) -> Void) { //returns the name of the current logged profile
        let parameters = ["fields": "first_name, last_name"]
        var fullName : String = ""
        var firstName : String = ""
        var lastName : String = ""
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            firstName = result.valueForKey("first_name") as! String
            lastName = result.valueForKey("last_name") as! String
            fullName = "\(firstName) \(lastName)"
            completion(result:fullName)
        }
    }
    
    func getFacebookID(completion:(result:String) -> Void) {
        let parameters = ["fields": "id"]
        var id : String!
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler {
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            id = result.valueForKey("id") as! String
            completion(result:id)
        }
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