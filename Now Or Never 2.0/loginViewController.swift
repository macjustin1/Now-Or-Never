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
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print ("Not logged in")
        }
        else {
            print("Logged in")
            self.loadViewController()
        }
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
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