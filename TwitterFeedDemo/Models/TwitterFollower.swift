//
//  TwitterFollowers.swift
//  SwiftDemo
//
//  Created by Ravi Shankar on 20/04/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import Foundation

struct TwitterFollower {
    var name: String?
    var screenName:String?
    var description: String?
    var profileURL: String?
    
    init (name: String,screenName:String, url: String) {
        self.name = name
        self.profileURL = url
        self.screenName = screenName
    }
}
