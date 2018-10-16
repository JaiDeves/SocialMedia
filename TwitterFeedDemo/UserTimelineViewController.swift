//
//  UserTimelineViewController.swift
//  FabricSampleApp
//
//  Created by Steven Hepting on 2/2/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

import UIKit
import  TwitterKit

class UserTimelineViewController: TWTRTimelineViewController {
    var screenName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.screenName = self.screenName ?? AppDelegate.shared.twitterUser?.screenName
        if let screenName = self.screenName{
            let client = TWTRAPIClient.withCurrentUser()
            self.dataSource = TWTRUserTimelineDataSource(screenName: screenName, apiClient: client)
            
            self.title = "@\(screenName)"
        }
    }

    func tweetView(tweetView: TWTRTweetView, didSelectTweet tweet: TWTRTweet) {
        print("Selected tweet with ID: \(tweet.tweetID)")
    }

}
