//
//  MyProfileView.swift
//  Now Or Never
//
//  Created by Justin Mac on 5/4/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MyProfileView: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioView: UITextView!
    var loginButton = FBSDKLoginButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "a47")
        nameLabel.text = "Justin"
        bioView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        loginButton.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height - 90)
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil {
            print("Login Complete")
        }
        else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
        self.performSegueWithIdentifier("showLoginController", sender: self)
    }
}
