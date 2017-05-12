//
//  User.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 5/12/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

import Foundation


class User {
    static let sharedInstance = User()
    
    public var userID: Int?
    public var firstName: String?
    public var lastName: String?
    public var birthDay: Date?
    public var pictureURL: String?
    
    
    private init() {
        print("User Initialized")
    }
}

