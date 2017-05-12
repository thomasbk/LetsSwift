//
//  FirstViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/19/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit
//import User

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print("Loaded first view")
        
        
        let myUser = User.sharedInstance
        
        myUser.userID = 3
        myUser.firstName = "Thomas"
        myUser.lastName = "Baltodano"
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

