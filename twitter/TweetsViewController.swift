//
//  TweetsViewController.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit
import AVFoundation

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetDetailViewControllerDelegate, TweetCreateViewControllerDelegate{


    @IBOutlet weak var infiniteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tweetsTableView: UITableView!

    var tweets: [Tweet] = []
    var sb = UIStoryboard(name: "Main", bundle: nil)
    var isInfiniteRefreshing = false
    var refreshControl: UIRefreshControl?
    var refreshLoadingView: UIView?
    var refreshArrowImageView: UIImageView?
    var isRefreshAnimating = false
    var arrowAlreadyRotated = false
    var downBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("down", ofType: "wav")!)
    var downBeepAudioPlayer = AVAudioPlayer()
    
    var upBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("up", ofType: "wav")!)
    var upBeepAudioPlayer = AVAudioPlayer()


    @IBAction func onNewTweet(sender: AnyObject) {
        var vc = sb.instantiateViewControllerWithIdentifier("CreateTweetNavigationController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func onRetweet(sender: AnyObject) {
        var indexPathRow = sender.tag
        var tweet = tweets[indexPathRow]

        // TODO make it more realtime and show error if it fails.
        tweet.retweeted = 1
        tweet.retweetCount! += 1
        var cell = self.tweetsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as TweetCell
        cell.tweet = tweet


        Tweet.retweet(tweet.id!, completion: {(error: NSError?) -> Void in
            if (error != nil) {
                println("error while retweeting! \(error)")
                tweet.retweeted = 0
                tweet.retweetCount! -= 1
                var cell = self.tweetsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as TweetCell
                cell.tweet = tweet

            } else {
                println("retweeted!!!!!  while retweeting!")
                self.tweets[indexPathRow] = tweet
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        var indexPathRow = sender.tag
        var tweet = tweets[indexPathRow]
        // TODO make it more realtime and show error if it fails.
        if (tweet.favorited == 1) {
            tweet.favorited = 0
            tweet.favoriteCount! -= 1
            var cell = self.tweetsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as TweetCell
            cell.tweet = tweet
            
            Tweet.unfavorite(tweet.id!, completion: {(error: NSError?) -> Void in
                if (error != nil) {
                    println("error while unfavoriting! \(error)")
                    tweet.favorited = 1
                    tweet.favoriteCount! += 1
                    cell.tweet = tweet
                } else {
                    println("unfavorited!!!!!")
                    self.tweets[indexPathRow] = tweet
                }
            })
        } else {
            tweet.favorited = 1
            tweet.favoriteCount! += 1
            var cell = self.tweetsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as TweetCell
            cell.tweet = tweet

            Tweet.favorite(tweet.id!, completion: {(error: NSError?) -> Void in
                if (error != nil) {
                    println("error while favoriting! \(error)")
                    tweet.favorited = 0
                    tweet.favoriteCount! -= 1
                    cell.tweet = tweet
                } else {
                    println("favorited!!!!!")
                    self.tweets[indexPathRow] = tweet
                }
            })
        }

    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    @IBAction func onReplyButtonClicked(sender: AnyObject) {
        
        var indexPathRow = sender.tag
        var vc = sb.instantiateViewControllerWithIdentifier("CreateTweetViewController") as CreateTweetViewController
        vc.replyToTweet = self.tweets[indexPathRow];
        
        println("\(indexPathRow)")
        
        var nc = CreateTweetNavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true, completion: nil)
    }


    func setupRefreshControl() {

        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        
        var attributedString = NSMutableAttributedString(string: "")
        self.refreshControl!.attributedTitle = attributedString
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, attributedString.length))
        self.refreshControl!.attributedTitle = attributedString
    
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
        self.refreshLoadingView!.backgroundColor = UIColor.clearColor()
        
        // Create the graphic image views
        self.refreshArrowImageView = UIImageView(image: UIImage(named: "refresh-arrow.png"))

    
        // Add the graphics to the loading view
        self.refreshLoadingView!.addSubview(self.refreshArrowImageView!)
    
        // Clip so the graphics don't stick out
        self.refreshLoadingView!.clipsToBounds = true;
    
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clearColor()

        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshLoadingView!)
    
        // Initalize flags
        self.isRefreshAnimating = false;
//        self.refreshControl!.tintColor = UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        // When activated, invoke our refresh function
 self.refreshControl!.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tweetsTableView!.addSubview(self.refreshControl!)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds;
    
        // Distance the table has been pulled >= 0
        var pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
    
        // Half the width of the table
        var midX = self.tweetsTableView!.frame.size.width / 2.0 - self.refreshArrowImageView!.frame.size.width/2.0;
    
        // Calculate the width and height of our graphics
        var arrowHeight = self.refreshArrowImageView!.bounds.size.height;
        
        var arrowHeighttHalf = arrowHeight / 2.0;

        // Calculate the pull ratio, between 0.0-1.0
        var pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
    
        // Set the Y coord of the graphics, based on pull distance
        var arrowY = pullDistance / 2.0 - arrowHeighttHalf;
        
        //NSLog("\(arrowY)   \(pullDistance)")
        
        
        if (arrowY > 20) {
            if (self.arrowAlreadyRotated == false && arrowY > 25 && self.isRefreshAnimating == false) {
                self.arrowAlreadyRotated = true
                downBeepAudioPlayer.play()
                animateRefreshArrow()

            }
            arrowY = 20
        }
        
        if (self.arrowAlreadyRotated == true && arrowY < 10.0 && self.isRefreshAnimating == false){
            self.arrowAlreadyRotated = false
            upBeepAudioPlayer.play()
            animateRefreshArrow()

        }
    
        // Set the graphic's frames
        var refreshArrowImageViewFrame = self.refreshArrowImageView!.frame;
        refreshArrowImageViewFrame.origin.x = midX;
        refreshArrowImageViewFrame.origin.y = arrowY;
    
        self.refreshArrowImageView!.frame = refreshArrowImageViewFrame
    
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
    
        self.refreshLoadingView!.frame = refreshBounds;
        

    }

    func animateRefreshArrow() {
        self.isRefreshAnimating = true
        UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
           self.refreshArrowImageView!.transform = CGAffineTransformRotate(self.refreshArrowImageView!.transform, CGFloat(M_PI))
        }) { (success) -> Void in
            self.isRefreshAnimating = false
        }
    }
    
    
    func refresh() {
        println("calling refresh..")
        var attributedString = NSMutableAttributedString(string: "Refreshing")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41.0/255.0, green: 47.0/255.0, blue: 51.0/255.0, alpha: 1.0), range: NSMakeRange(0, attributedString.length))
        self.refreshControl!.attributedTitle = attributedString

        Tweet.getHomeTimeline(nil, completion: {(tweets: [Tweet]?, error: NSError?) -> Void in
            if (tweets != nil) {
                self.tweets = tweets!
                println("Done refreshing")
                var attributedString = NSMutableAttributedString(string: "")
                self.refreshControl!.attributedTitle = attributedString
                self.refreshControl!.endRefreshing()
                self.tweetsTableView.reloadData()
            } else {
                println("Failed to get the tweets \(error!)")
                var attributedString = NSMutableAttributedString(string: "")
                self.refreshControl!.attributedTitle = attributedString
                self.refreshControl!.endRefreshing()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 89.0;
        setupRefreshControl()


        Tweet.getHomeTimeline(nil, completion: {(tweets: [Tweet]?, error: NSError?) -> Void in
            if (tweets != nil) {
                self.tweets = tweets!
                self.tweetsTableView.reloadData()
            } else {
                println("Failed to get the tweets \(error!)")
            }
        })
        
        // This will listen to the tweets when they are created
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newTweetCreated:", name:"NewTweetCreated", object: nil)

        infiniteActivityIndicator.hidden = true
        // Do any additional setup after loading the view.
        
        downBeepAudioPlayer = AVAudioPlayer(contentsOfURL: downBeep, error: nil)
        downBeepAudioPlayer.prepareToPlay()
        upBeepAudioPlayer = AVAudioPlayer(contentsOfURL: upBeep, error: nil)
        upBeepAudioPlayer.prepareToPlay()

    }

    func newTweetCreated(notification: NSNotification){
        //Action take on Notification
        println("I got the tweet in TweetsViewController")
        var tweet = notification.object as Tweet
        self.tweets.insert(tweet, atIndex: 0)
        NSLog("Got the tweet in the main controller")
        self.tweetsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.parentViewController = self
        cell.indexPathRow = indexPath.row
        cell.tweet = tweets[indexPath.row]
        
        if (tweets.count - indexPath.row == 1 && !self.isInfiniteRefreshing) {
            infiniteActivityIndicator.hidden = false
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                self.loadMoreTweets()
            })
        }

        return cell
    }
    
    func loadMoreTweets() {
        
        var params: NSDictionary = ["max_id": self.tweets[tweets.count-1].id!]
        self.isInfiniteRefreshing = true
        //println("\(params)")
        Tweet.getHomeTimeline(params, completion: {(newTweets: [Tweet]?, error: NSError?) -> Void in
            if (newTweets != nil) {
                self.tweets += newTweets!
                self.tweetsTableView.reloadData()
                self.infiniteActivityIndicator.hidden = true
                self.isInfiniteRefreshing = false
            } else {
                println("Failed to get the tweets \(error!)")
            }
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var tweetDetailViewController: TweetDetailViewController = segue.destinationViewController as TweetDetailViewController
        var tweetIndex = tweetsTableView.indexPathForSelectedRow()!.row
        self.tweetsTableView.deselectRowAtIndexPath(tweetsTableView.indexPathForSelectedRow()!, animated: false)
        var selectedTweet = self.tweets[tweetIndex]
        tweetDetailViewController.tweet = selectedTweet
        tweetDetailViewController.indexPathRow = tweetIndex
        tweetDetailViewController.delegate = self
    }
    
    func backButtonClicked(tweet: Tweet, indexPathRow: Int) {
        self.tweets[indexPathRow] = tweet
        var cell = self.tweetsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as TweetCell
        cell.tweet = tweet
    }
    
    func onNewTweet(tweet: Tweet) {

    }
}
