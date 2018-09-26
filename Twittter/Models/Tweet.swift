//
//  Tweet.swift
//  Twittter
//
//  Created by Victor Li on 9/25/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import Foundation

struct Tweet {
    let id: Int64 // For favoriting, retweeting & replying
    let text: String // Text content of tweet
    let favoriteCount: Int // Update favorite count label
    let favorited: Bool? // Configure favorite button
    let retweetCount: Int // Update favorite count label
    let retweeted: Bool // Configure retweet button
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
        
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as! Int
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        favorited = dictionary["favorited"] as? Bool
        
        // initialize user
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        // Format and set createdAtString
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String and set the createdAtString property
        self.createdAtString = formatter.string(from: date)
    }
    
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        return array.compactMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
        })
    }
}
