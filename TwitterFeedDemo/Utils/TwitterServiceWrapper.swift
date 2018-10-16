//
//  Authenticator.swift
//  SwiftDemo
//
//  Created by Ravi Shankar on 14/04/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import Foundation
import TwitterKit

protocol TwitterFollowerDelegate{
    func finishedDownloading(follower:TwitterFollower)
}

public class TwitterServiceWrapper:NSObject {
    
    
    
    var delegate:TwitterFollowerDelegate?
    
    let consumerKey = Bundle.main.infoDictionary!["TwitterConsumerKey"] as! String
    let consumerSecret = Bundle.main.infoDictionary!["TwitterConsumerSecret"] as! String
    let host = "https://api.twitter.com/oauth2/token"
    
    // MARK:- Bearer Token
    func getBearerToken(completion:@escaping (_ bearerToken: String) ->Void) {
        
//        serviceWrapper.getResponseForRequest(url: "https://api.twitter.com/1.1/followers/list.json?screen_name=rshankra&skip_status=true&include_user_entities=false")
        

        let components = NSURLComponents()
        components.scheme = "https";
        components.host = self.host
        components.path = "/oauth2/token";

        let url = components.url;
        
        var request = URLRequest(url:url!)
        
        request.httpMethod = "GET"
        request.addValue("Basic " + getBase64EncodeString(), forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let grantType =  "grant_type=client_credentials"
        
        request.httpBody = grantType.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print(String.init(data: data, encoding: String.Encoding.utf8))
            do {
                if let results: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    if let token = results["access_token"] as? String {
                        completion(token)
                    } else {
                        print(results["errors"])
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    
    // MARK:- base64Encode String
    
    func getBase64EncodeString() -> String {
        
        let consumerKeyRFC1738 = consumerKey.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
        
        let consumerSecretRFC1738 =  consumerKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        
        let concatenateKeyAndSecret = consumerKeyRFC1738! + ":" + consumerSecretRFC1738!
        
        let secretAndKeyData = concatenateKeyAndSecret.data(using: String.Encoding.ascii, allowLossyConversion: true)
        
        let base64EncodeKeyAndSecret = secretAndKeyData!.base64EncodedString(options: Data.Base64EncodingOptions())
            
//            .base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
        
        return base64EncodeKeyAndSecret
    }
    
    // MARK:- Service Call
    
    func getResponseForRequest(url:String,method:String,params:[AnyHashable:Any]?) {
        
        let client = TWTRAPIClient.withCurrentUser()
        
        var clientRequest = client.urlRequest(withMethod: method, urlString: url, parameters:params , error: NSErrorPointer.none)

        client.sendTwitterRequest(clientRequest) { (response, data, error) in
            print(String.init(data: data!, encoding: String.Encoding.utf8))
            self.processResult(data: data!, response: response, error: error)
        }
        
        //        clientRequest.addValue("Basic " + getBase64EncodeString(), forHTTPHeaderField: "Authorization")
        //        clientRequest.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.dataTask(with: clientRequest, completionHandler: { (data, response, error) in
//            print(String.init(data: data!, encoding: String.Encoding.utf8))
//            self.processResult(data: data!, response: response!, error: error)
//        })
//        task.resume()
    }
    
    // MARK:- Process results
    
    func processResult(data: Data, response:URLResponse?, error: Error?) {
        guard let response = response else {return}
        do {
            
            if let results: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                
                if let users = results["users"] as? [NSDictionary] {
                    for user in users{
                        let follower = TwitterFollower(name: user["name"] as! String, screenName: user["screen_name"] as! String, url:user["profile_image_url"] as! String)
                        self.delegate?.finishedDownloading(follower: follower)
                    }
                } else {
                    print(results["errors"])
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
