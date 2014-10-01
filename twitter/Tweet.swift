//
//  Tweet.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    // Add all the class variables.
    
    var user: User?
    var retweetedBy: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoriteCount: Int?
    var retweetCount: Int?
    var userReadableCreatedTime: String?
    var id: String?
    var retweeted: Int?
    var favorited: Int?
    var entities: NSDictionary?

    class func formatCreatedTimeToUserReadableTime(createdAt: NSDate) -> String {
        
        var timeSinceCreation = createdAt.timeIntervalSinceNow
        var timeSinceCreationInt =  Int(timeSinceCreation) * -1
        var timeSinceCreationMins = timeSinceCreationInt/60 as Int
        
        println("TIME \(timeSinceCreationMins)")
        if (timeSinceCreationMins == 0) {
            return "now"
        } else if (timeSinceCreationMins >= 1 && timeSinceCreationMins < 60) {
            return "\(timeSinceCreationMins)m"
        } else if (timeSinceCreationMins < 1440) {
            return "\(timeSinceCreationMins/60)h"
        } else if (timeSinceCreationMins >= 1440) {
            return "\(timeSinceCreationMins/1440)d"
        }
        return "now"
    }
    
    init(dictionary: NSDictionary) {
        println("Tweet: \(dictionary)")
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        id = dictionary["id_str"] as? String
        //id = "\(intid!)"
        retweeted = dictionary["retweeted"] as? Int
        favorited = dictionary["favorited"] as? Int
        entities = dictionary["entities"] as? NSDictionary

        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        userReadableCreatedTime = Tweet.formatCreatedTimeToUserReadableTime(createdAt!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            if (dictionary["retweeted_status"] != nil) {
                var tweet = Tweet(dictionary: dictionary["retweeted_status"] as NSDictionary)
                tweet.retweetedBy = User(dictionary: dictionary["user"] as NSDictionary)
                tweets.append(tweet)
            } else {
                tweets.append(Tweet(dictionary: dictionary))
            }

        }
        return tweets
    }
    
    class func getHomeTimeline(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("user: \(response)")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get the User data")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    class func retweet(id: String, completion: (error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("user: \(response)")
                completion(error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get retweet")
                completion(error: error)
            }
        )
    }
    
    class func favorite(id: String, completion: (error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id)", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("user: \(response)")
                completion(error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to favorite")
                completion(error: error)
            }
        )
    }
    
    class func unfavorite(id: String, completion: (error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("user: \(response)")
                completion(error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to unfavorite")
                completion(error: error)
            }
        )
    }
    
    
    class func newTweet(text: String, inReplyToTweetId: String?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        let params = ["status":text] as NSMutableDictionary
        if let replyToTweetId = inReplyToTweetId {
            params["in_reply_to_status_id"] = replyToTweetId
        }
        println(params)
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            println("Success while tweeting: \(response)")
            var tweet = Tweet(dictionary: response as NSDictionary)
            completion(tweet: tweet, error: nil)
            
        }) {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
            completion(tweet: nil, error: error)
        }
    }
    
    
}
