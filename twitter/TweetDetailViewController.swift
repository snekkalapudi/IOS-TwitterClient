//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit


protocol TweetDetailViewControllerDelegate {
    func backButtonClicked(tweet:Tweet, indexPathRow: Int)
}

class TweetDetailViewController: UIViewController {

    var delegate: TweetDetailViewControllerDelegate?

    var tweet: Tweet?
    var indexPathRow = -1

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileThumbView: UIImageView!
    @IBOutlet weak var retweetedIconView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var tweetCreatedAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var lineSeparatorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLineSeparator: UIView!
    @IBOutlet weak var profileThumbViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var sb = UIStoryboard(name: "Main", bundle: nil)
    
    @IBAction func onReplyImageButton(sender: AnyObject) {
        self.onReply(self)
    }

    @IBAction func onReply(sender: AnyObject) {
        
        var vc = sb.instantiateViewControllerWithIdentifier("CreateTweetViewController") as CreateTweetViewController
        vc.replyToTweet = self.tweet;
        
        var nc = CreateTweetNavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true, completion: nil)
    }

    @IBAction func onRetweet(sender: AnyObject) {
        // TODO make it more realtime and show error if it fails.
        self.tweet!.retweeted = 1
        self.tweet!.retweetCount! += 1
        self.retweetButton.enabled = false
        self.viewDidLoad()

        Tweet.retweet(self.tweet!.id!, completion: {(error: NSError?) -> Void in
            if (error != nil) {
                println("error while retweeting! \(error)")
                self.tweet!.retweeted = 0
                self.tweet!.retweetCount! -= 1
                self.retweetButton.enabled = true
                self.viewDidLoad()
            } else {
                println("retweeted!!!!!  while retweeting!")
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        // TODO make it more realtime and show error if it fails.
        if (self.tweet!.favorited == 0) {
            self.tweet!.favorited = 1
            self.tweet!.favoriteCount! += 1
            self.viewDidLoad()
            Tweet.favorite(self.tweet!.id!, completion: {(error: NSError?) -> Void in
                if (error != nil) {
                    println("error while favoriting! \(error)")
                    self.tweet!.favorited = 0
                    self.tweet!.favoriteCount! -= 1
                    self.viewDidLoad()
                } else {
                    println("Favorited!!!!!!")
                }
            })
        } else {
            self.tweet!.favorited = 0
            self.tweet!.favoriteCount! -= 1
            self.viewDidLoad()

            Tweet.unfavorite(self.tweet!.id!, completion: {(error: NSError?) -> Void in
                if (error != nil) {
                    println("error while unfavoriting! \(error)")
                    self.tweet!.favorited = 0
                    self.tweet!.favoriteCount! -= 1
                    self.viewDidLoad()
                } else {
                    println("unFavorited!!!!!!")
                }
            })
        }
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        // Going back to parent view controller
        println("GOING back HOME!!")
        self.delegate?.backButtonClicked(self.tweet!, indexPathRow: self.indexPathRow)
    }
    
    func populateLineSeparatorViews() {
        favoriteCountLabel.hidden = true
        favoritesLabel.hidden = true
        retweetCountLabel.hidden = true
        retweetsLabel.hidden = true
        if (self.tweet!.retweetCount! == 0 && self.tweet!.favoriteCount! == 0) {
            topLineSeparator.hidden = true
            retweetCountLabel.hidden = true
            favoriteCountLabel.hidden = true
            favoritesLabel.hidden = true
            retweetsLabel.hidden = true
            lineSeparatorTopConstraint.constant = 10
        } else {
            topLineSeparator.hidden = false
            lineSeparatorTopConstraint.constant = 46
            
        }
        if (self.tweet!.favoriteCount >= 1) {
            if (self.tweet!.favoriteCount == 1) {
                favoritesLabel.text = "FAVORITE"
            }
            favoriteCountLabel.hidden = false
            favoritesLabel.hidden = false
            favoriteCountLabel.text = "\(self.tweet!.favoriteCount!)"
            if (self.tweet!.retweetCount! == 0) {
                
            }
        }
        if (self.tweet!.retweetCount >= 1) {
            if (self.tweet!.retweetCount == 1) {
                retweetsLabel.text = "RETWEET"
            }
            retweetCountLabel.hidden = false
            retweetsLabel.hidden = false
            retweetCountLabel.text = "\(self.tweet!.retweetCount!)"
        }
    }
    
    func populateRetweetedByViews() {
        if let retweetedBy = self.tweet!.retweetedBy {
            self.retweetedLabel.text = "\(retweetedBy.name!) retweeted"
            self.retweetedIconView.hidden = false
            self.retweetedLabel.hidden = false
        } else {
            self.retweetedIconView.hidden = true
            self.retweetedLabel.hidden = true
            self.profileThumbViewTopConstraint.constant = 12
            self.nameLabelTopConstraint.constant = 12
        }

    }
    
    func populateButtonViews() {
        if (tweet?.retweeted == 1) {
            self.retweetButton.enabled = false
            let image = UIImage(named: "retweet-on.png") as UIImage
            self.retweetButton.setImage(image, forState: UIControlState.Disabled)
        }
        
        if (tweet?.favorited == 1) {
            let image = UIImage(named: "favorite-on.png") as UIImage
            self.favoriteButton.setImage(image, forState: UIControlState.Normal)
        } else {
            let image = UIImage(named: "favorite-light.png") as UIImage
            self.favoriteButton.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileThumbView.setImageWithURL(NSURL(string: tweet!.user!.profileImageUrl!))
        nameLabel.text = tweet!.user?.name!
        handleLabel.text = "@\(tweet!.user!.screenName!)"
        tweetLabel.text = tweet!.text!
        
        profileThumbView.layer.cornerRadius = 5;
        profileThumbView.clipsToBounds = true;
        populateLineSeparatorViews()
        populateRetweetedByViews()
        populateButtonViews()

        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM-dd-yy, hh:mm a"
        tweetCreatedAtLabel.text = dateFormat.stringFromDate(tweet!.createdAt!)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
