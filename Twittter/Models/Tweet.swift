//
//  Tweet.swift
//  Twittter
//
//  Created by Victor Li on 9/25/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import Foundation
import DateToolsSwift

struct Tweet {
    let id_str: String // For favoriting, retweeting & replying
    let text: String // Text content of tweet
    var favoriteCount: Int // Update favorite count label
    var favorited: Bool // Configure favorite button
    var retweetCount: Int // Update favorite count label
    var retweeted: Bool // Configure retweet button
    let user: User // Author of the Tweet
    let createdAtString: String // String representation of date posted
    
    // For Retweets
    let retweetedByUser: User?  // user who retweeted if tweet is retweet
    
    init(dictionary: [String: Any]) {
        var dictionary = dictionary
        
        // Is this a re-tweet?
        if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.retweetedByUser = User(dictionary: userDictionary)
            
            // Change tweet to original tweet
            dictionary = originalTweet
        } else {
            self.retweetedByUser = nil
        }
        
        id_str = dictionary["id_str"] as! String
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as! Int
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        favorited = dictionary["favorited"] as? Bool ?? false
        
        // initialize user
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        // Format and set createdAtString
        createdAtString = dictionary["created_at"] as! String
        
    }
    
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        return array.compactMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
        })
    }
}
