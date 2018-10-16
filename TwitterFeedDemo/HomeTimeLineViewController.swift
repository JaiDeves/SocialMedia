//
//  HomeTimeLineViewController.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit

class HomeTimeLineViewController: TWTRTimelineViewController {
    var screenName:String?
    var tweets:[TWTRTweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHomeTimeLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "narendramodi"
        self.screenName = self.screenName ?? AppDelegate.shared.twitterUser?.screenName
        if let screenName = self.screenName{
            let client = TWTRAPIClient.withCurrentUser()
            self.dataSource = TWTRUserTimelineDataSource(screenName: screenName, apiClient: client)
            
            self.title = "@\(screenName)"
        }
    }
    
    func getHomeTimeLine(){
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["include_user_entities":"false"]
        let client = TWTRAPIClient.withCurrentUser()
        
        let clientRequest = client.urlRequest(withMethod: "GET", urlString: url, parameters:params , error: NSErrorPointer.none)
        client.sendTwitterRequest(clientRequest) { (response, data, error) in
            
            if let data = data{
                print(String.init(data: data, encoding: String.Encoding.utf8))
                do{
                    if let jsonArray =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [NSDictionary]{
                        self.tweets = TWTRTweet.tweets(withJSONArray: jsonArray) as! [TWTRTweet]
                    }
                }catch{}
            }
            
        }
    }
    func tweetView(tweetView: TWTRTweetView, didSelectTweet tweet: TWTRTweet) {
        print("Selected tweet with ID: \(tweet.tweetID)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TWTRTweetTableViewCell
        cell.configure(with: tweets[indexPath.row])
        return cell
    }
}
