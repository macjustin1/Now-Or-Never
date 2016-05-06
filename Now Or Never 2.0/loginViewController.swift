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
            
            self.loadViewController()
        }
        else {
            print("Not Logged in")
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