//
//  FacebookFeed.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/11/18.
//  Copyright © 2018 apple. All rights reserved.
//


import Foundation
import ObjectMapper


class FacebookFeed : NSObject, NSCoding, Mappable{
    
    var likes:Likes?
    var actions : [Action]?
    var place:Place?
    var createdTime : String?
    var from : From?
    var icon : String?
    var id : String?
    var link : String?
    var message : String?
    var name : String?
    var picture : String?
    var type : String?
    var updatedTime : String?
    var _description:String?
    var full_picture:String?
    
    class func responseMapping(dict:NSDictionary)->[FacebookFeed]?{
        guard let dataArray = dict.value(forKey: "data") as? NSArray else { return  nil }
        let feedArray = dataArray.compactMap{FacebookFeed(JSON: $0 as! [String:Any]) }
        return feedArray
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return FacebookFeed()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        actions <- map["actions"]
        createdTime <- map["created_time"]
        from <- map["from"]
        icon <- map["icon"]
        id <- map["id"]
        link <- map["link"]
        message <- map["message"]
        name <- map["name"]
        picture <- map["picture"]
        type <- map["type"]
        updatedTime <- map["updated_time"]
        place <- map["place"]
        likes <- map["likes"]
        full_picture <- map["full_picture"]
        _description <- map["description"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        actions = aDecoder.decodeObject(forKey: "actions") as? [Action]
        createdTime = aDecoder.decodeObject(forKey: "created_time") as? String
        from = aDecoder.decodeObject(forKey: "from") as? From
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        link = aDecoder.decodeObject(forKey: "link") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        picture = aDecoder.decodeObject(forKey: "picture") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        updatedTime = aDecoder.decodeObject(forKey: "updated_time") as? String
        place = aDecoder.decodeObject(forKey: "place") as? Place
           likes = aDecoder.decodeObject(forKey: "likes") as? Likes
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if actions != nil{
            aCoder.encode(actions, forKey: "actions")
        }
        if createdTime != nil{
            aCoder.encode(createdTime, forKey: "created_time")
        }
        if from != nil{
            aCoder.encode(from, forKey: "from")
        }
        if icon != nil{
            aCoder.encode(icon, forKey: "icon")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if link != nil{
            aCoder.encode(link, forKey: "link")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if picture != nil{
            aCoder.encode(picture, forKey: "picture")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if updatedTime != nil{
            aCoder.encode(updatedTime, forKey: "updated_time")
        }
        if place != nil{
            aCoder.encode(place, forKey: "place")
        }
        if likes != nil{
            aCoder.encode(likes, forKey: "likes")
        }
    }
    
}


class From : NSObject, NSCoding, Mappable{
    
    var id : String?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return From()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}

class Action : NSObject, NSCoding, Mappable{
    
    var link : String?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Action()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        link <- map["link"]
        name <- map["name"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        link = aDecoder.decodeObject(forKey: "link") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if link != nil{
            aCoder.encode(link, forKey: "link")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}



class Place : NSObject, NSCoding, Mappable{
    
    var id : String?
    var location : Location?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Place()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        location <- map["location"]
        name <- map["name"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        location = aDecoder.decodeObject(forKey: "location") as? Location
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}





class Location : NSObject, NSCoding, Mappable{
    
    var city : String?
    var country : String?
    var latitude : Float?
    var longitude : Float?
    var street : String?
    var zip : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Location()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        city <- map["city"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        street <- map["street"]
        zip <- map["zip"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Float
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Float
        street = aDecoder.decodeObject(forKey: "street") as? String
        zip = aDecoder.decodeObject(forKey: "zip") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if street != nil{
            aCoder.encode(street, forKey: "street")
        }
        if zip != nil{
            aCoder.encode(zip, forKey: "zip")
        }
        
    }
    
}



class Likes : NSObject, NSCoding, Mappable{
    
    var data : [Likesdata]?
    var paging : Paging?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Likes()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        paging <- map["paging"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObject(forKey: "data") as? [Likesdata]
        paging = aDecoder.decodeObject(forKey: "paging") as? Paging
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if paging != nil{
            aCoder.encode(paging, forKey: "paging")
        }
        
    }
    
}

class Likesdata : NSObject, NSCoding, Mappable{
    
    var id : String?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Likesdata()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}

class Paging : NSObject, NSCoding, Mappable{
    
    var cursors : Cursor?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Paging()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        cursors <- map["cursors"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cursors = aDecoder.decodeObject(forKey: "cursors") as? Cursor
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cursors != nil{
            aCoder.encode(cursors, forKey: "cursors")
        }
        
    }
    
}

class Cursor : NSObject, NSCoding, Mappable{
    
    var after : String?
    var before : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Cursor()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        after <- map["after"]
        before <- map["before"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        after = aDecoder.decodeObject(forKey: "after") as? String
        before = aDecoder.decodeObject(forKey: "before") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if after != nil{
            aCoder.encode(after, forKey: "after")
        }
        if before != nil{
            aCoder.encode(before, forKey: "before")
        }
        
    }
    
}
