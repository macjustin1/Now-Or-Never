//
//  ViewController.swift
//  Now Or Never 2.0
//
//  Created by Justin Mac on 4/30/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import CloudKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var refresh : UIRefreshControl!
    
    
    //var profiles = [Person]()
    var profileRecords = [CKRecord]()
    var currentProfile = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to load profiles")
        refresh.addTarget(self, action: "loadProfiles", forControlEvents: .ValueChanged)
        self.collectionView.addSubview(refresh) //adds a refresh action to the collectionView so we can update profiles
        
        
        navigationController!.navigationBar.barTintColor = UIColor(colorLiteralRed: 87/255, green: 143/255, blue: 234/255, alpha: 0.1) //changes the navigation bar color to light blue, divide by 255 to convert RGB
        //Status Bar White Font
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        loadProfiles()
        
    }
    
    func loadProfiles() -> Void { //parameter: index
        //populate Profile name, images, bios, age
        profileRecords = [CKRecord]()
        let publicData = CKContainer.defaultContainer().publicCloudDatabase
        let query = CKQuery(recordType: "Person", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        //sort query here later
        publicData.performQuery(query, inZoneWithID: nil, completionHandler: { (results:[CKRecord]?, error: NSError?) -> Void in //perform a database query to cloud kit to load
            if let profiles = results {
                self.profileRecords = profiles //load them one at a time
                dispatch_async(dispatch_get_main_queue(), { //push the current info into the main thread
                    self.collectionView.reloadData()
                    //self.refresh.endRefreshing()
                })
            }
            else {
                print("error in populating profiles")
                print(error)
            }
        })
        var name: String = "Default"
        var email: String = "Default"
        var ID : String = ""
        loginViewController().getFullName({
            (result)->Void in
            name = result
            print("Name is: \(name)")
        })
        loginViewController().getEmail({
            (result)->Void in
            email = result
            print("Email is: \(email)")
        })
        loginViewController().getFacebookID({
            (result)->Void in
            ID = result
            print("ID is: \(ID)")
        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize { //corrects auto layout, using 2 rows
        return CGSize(width: self.view.bounds.width/2, height: self.view.bounds.height/4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //required function for UICollectionView
         return profileRecords.count //limit a specific profile amount
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! profileImageCell //searches for identifier labeled "cell" from storyboard
        let profile = profileRecords[indexPath.row]
        if let profileName = profile["Name"] as? String {
            cell.nameLabel?.text = profileName //automatically increments the indexPath like ++i
        }
        if let profileImage = profile["Image"] as? CKAsset,
            data = NSData(contentsOfURL: profileImage.fileURL),
            image = UIImage(data: data) { //cannot directly convert Asset to UIImage
            cell.imageView?.image = image//populate the imageViews from the collectionView cells with the profileImages in database
        }
        return cell
    } //reuses cell for all cells in UICollectionView
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showProfile", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfile" {
            let backButton = UIBarButtonItem()
            backButton.title = "" //want an empty title, rather than app name near back button
            navigationItem.backBarButtonItem = backButton //recreates bar button with empty title
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()! //get the number of selected items in our collectionView
            let indexPath = indexPaths[0] as NSIndexPath //start at first i
            
            let vc = segue.destinationViewController as! profileViewController
            
            //set the profile view up
            let profile = profileRecords[indexPath.row]
            if let profileImage = profile["Image"] as? CKAsset, //find the profile Image for the profileView
                data = NSData(contentsOfURL: profileImage.fileURL),
                image = UIImage(data: data) { //cannot directly convert Asset to UIImage
                vc.image = image
            }
            if let profileName = profile["Name"] as? String {
                vc.name = profileName
            }
            if let profileBio = profile["Bio"] as? String {
                vc.bio = profileBio
            }
            //print(profileNames[indexPath.row])
            //vc.title = self.profileNames[indexPath.row]
        }
    }

}

