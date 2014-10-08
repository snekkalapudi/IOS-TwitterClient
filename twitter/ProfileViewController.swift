//
//  ProfileViewController.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func hamburgerMenuClicked()
}


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileTableView: UITableView!

    var profileDetailNameAndLocationScrollView: UIScrollView!
    var profileDetailHeaderView: UIView!
    var profileDetailHeaderNameView: UIView!
    var profileDetailHeaderLocationView: UIView!
    var profileDetailHeaderLineView: UIView!
    var profileDetailBannerImageView: UIImageView!
    var profileDetailThumbImageView: UIImageView!
    var profileDetailNameLabel: UILabel!
    var profileDetailHandleLabel: UILabel!
    var profileDetailTweetsCountLabel: UILabel!
    var profileDetailFollowersCountLabel: UILabel!
    var profileDetailFollowingCountLabel: UILabel!
    var profileDetailTweetsLabel: UILabel!
    var profileDetailFollowersLabel: UILabel!
    var profileDetailFollowingLabel: UILabel!
    var profileDetailLocationLabel: UILabel!
    var profileDetailTaglineLabel: UILabel!
    
    var profileDetailThumbImageCenter: CGPoint!
    var profileDetailNameCenter: CGPoint!
    var profileDetailHandleCenter: CGPoint!
    var profileDetailTweetsCountCenter: CGPoint!
    var profileDetailTweetsLabelCenter: CGPoint!
    var profileDetailFollowersCountCenter: CGPoint!
    var profileDetailFollowersLabelCenter: CGPoint!
    var profileDetailFollowingCountCenter: CGPoint!
    var profileDetailFollowingLabelCenter: CGPoint!
    var profileDetailHeaderLineCenter: CGPoint!
    var profileTableViewFrame: CGRect!
    var profileDetailHeaderViewFrame: CGRect!
    var profileDetailBannerImageViewFrame: CGRect!
    var visualEffectView: UIVisualEffectView!

    var user: User?
    var tweets: [Tweet] = []
    
    var blurEffectAdded = false
    
    var profileView = false
    var delegate:ProfileViewControllerDelegate?

    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBAction func onHomeClick(sender: UIBarButtonItem) {
        if (profileView) {
            self.delegate?.hamburgerMenuClicked()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func createProfileDetailHeaderView() {
        let width = view.frame.width
        //let starty = CGFloat(self.navigationController?.navigationBar.frame.height)
        
        profileDetailHeaderView = UIView(frame: CGRect(x: 0, y: 64, width: width, height: 215))

        // Add the banner
        profileDetailBannerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: 165))
        profileDetailHeaderView.addSubview(profileDetailBannerImageView)
        
        // Add the line seperator
        profileDetailHeaderLineView = UIView(frame: CGRect(x: 0, y: 214, width: width, height: 1))
        profileDetailHeaderLineView.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        profileDetailHeaderView.insertSubview(profileDetailHeaderLineView, belowSubview: profileDetailBannerImageView)
        
        // Add the scroll view
        profileDetailNameAndLocationScrollView  = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 165)) as UIScrollView
        profileDetailHeaderNameView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 165))
        profileDetailHeaderLocationView = UIView(frame: CGRect(x: width, y: 0, width: width, height: 165))
        
        
        
        // Add the thumb view to name view
        profileDetailThumbImageView = UIImageView(frame: CGRect(x: width/2 - 30, y: 20, width: 60, height: 60))
        profileDetailHeaderNameView.addSubview(profileDetailThumbImageView)
        
        
        // Add the name
        profileDetailNameLabel = UILabel(frame: CGRectMake(0, 0, 200, 17))
        profileDetailNameLabel.center = CGPointMake(width/2, 100)
        profileDetailNameLabel.textAlignment = NSTextAlignment.Center
        profileDetailNameLabel.textColor = UIColor.whiteColor()
        profileDetailNameLabel.font = UIFont.boldSystemFontOfSize(16)
        profileDetailHeaderNameView.addSubview(profileDetailNameLabel)
        
        // Add the handle
        profileDetailHandleLabel = UILabel(frame: CGRectMake(0, 0, 200, 17))
        profileDetailHandleLabel.center = CGPointMake(width/2, 125)
        profileDetailHandleLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        profileDetailHandleLabel.textAlignment = NSTextAlignment.Center
        profileDetailHandleLabel.textColor = UIColor.whiteColor()
        profileDetailHeaderNameView.addSubview(profileDetailHandleLabel)
        profileDetailNameAndLocationScrollView.addSubview(profileDetailHeaderNameView)

        // Add location information
        // Add the location
        profileDetailLocationLabel = UILabel(frame: CGRectMake(0, 0, 300, 17))
        profileDetailLocationLabel.center = CGPointMake(width/2, 50)
        profileDetailLocationLabel.textAlignment = NSTextAlignment.Center
        profileDetailLocationLabel.textColor = UIColor.whiteColor()
        profileDetailLocationLabel.font = UIFont.boldSystemFontOfSize(16)
//        profileDetailLocationLabel.text = "San Francisco"
        profileDetailHeaderLocationView.addSubview(profileDetailLocationLabel)
        
        // Add the Tagline
        profileDetailTaglineLabel = UILabel(frame: CGRectMake(0, 0, 300, 60))
        profileDetailTaglineLabel.center = CGPointMake(width/2, 100)
        profileDetailTaglineLabel.font = UIFont.boldSystemFontOfSize(14)
//        profileDetailTaglineLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        profileDetailTaglineLabel.textAlignment = NSTextAlignment.Center
        profileDetailTaglineLabel.textColor = UIColor.whiteColor()
//        profileDetailTaglineLabel.text = "This is mind blowing!"
        profileDetailTaglineLabel.numberOfLines = 0;
        profileDetailHeaderLocationView.addSubview(profileDetailTaglineLabel)

        profileDetailNameAndLocationScrollView.addSubview(profileDetailHeaderLocationView)
        
        // Add the scroll view to the main view
        profileDetailHeaderView.addSubview(profileDetailNameAndLocationScrollView)
        
        // Add the tweets count Label
        profileDetailTweetsCountLabel = UILabel(frame: CGRectMake(15, 172, 50, 17))
        profileDetailTweetsCountLabel.font = UIFont.boldSystemFontOfSize(14)
        profileDetailTweetsCountLabel.textAlignment = NSTextAlignment.Left
        profileDetailTweetsCountLabel.textColor = UIColor.blackColor()
        profileDetailHeaderView.insertSubview(profileDetailTweetsCountLabel, belowSubview: profileDetailBannerImageView)
        
        // Add the Followers count Label
        profileDetailFollowersCountLabel = UILabel(frame: CGRectMake(15 + width/3, 172, 50, 17))
        profileDetailFollowersCountLabel.font = UIFont.boldSystemFontOfSize(14)
        profileDetailFollowersCountLabel.textAlignment = NSTextAlignment.Left
        profileDetailFollowersCountLabel.textColor = UIColor.blackColor()
        profileDetailHeaderView.insertSubview(profileDetailFollowersCountLabel, belowSubview: profileDetailBannerImageView)
        
        // Add the Following count Label
        profileDetailFollowingCountLabel = UILabel(frame: CGRectMake(15 + 2*width/3, 172, 50, 17))
        profileDetailFollowingCountLabel.font = UIFont.boldSystemFontOfSize(14)
        profileDetailFollowingCountLabel.textAlignment = NSTextAlignment.Left
        profileDetailFollowingCountLabel.textColor = UIColor.blackColor()
        profileDetailHeaderView.insertSubview(profileDetailFollowingCountLabel, belowSubview: profileDetailBannerImageView)
        
        // Add the tweets count Label
        profileDetailTweetsLabel = UILabel(frame: CGRectMake(15, 190, 80, 17))
        profileDetailTweetsLabel.font = UIFont.boldSystemFontOfSize(11)
        profileDetailTweetsLabel.textAlignment = NSTextAlignment.Left
        profileDetailTweetsLabel.textColor = UIColor.grayColor()
        profileDetailTweetsLabel.text = "TWEETS"
        profileDetailHeaderView.insertSubview(profileDetailTweetsLabel, belowSubview: profileDetailBannerImageView)
        
        // Add the Followers count Label
        profileDetailFollowersLabel = UILabel(frame: CGRectMake(15 + width/3, 190, 100, 17))
        profileDetailFollowersLabel.font = UIFont.boldSystemFontOfSize(11)
        profileDetailFollowersLabel.textAlignment = NSTextAlignment.Left
        profileDetailFollowersLabel.textColor = UIColor.grayColor()
        profileDetailFollowersLabel.text = "FOLLOWERS"
        profileDetailHeaderView.insertSubview(profileDetailFollowersLabel, belowSubview: profileDetailBannerImageView)
        
        // Add the Following count Label
        profileDetailFollowingLabel = UILabel(frame: CGRectMake(15 + 2*width/3, 190, 100, 17))
        profileDetailFollowingLabel.font = UIFont.boldSystemFontOfSize(11)
        profileDetailFollowingLabel.textAlignment = NSTextAlignment.Left
        profileDetailFollowingLabel.textColor = UIColor.grayColor()
        profileDetailFollowingLabel.text = "FOLLOWING"
        profileDetailHeaderView.insertSubview(profileDetailFollowingLabel, belowSubview: profileDetailBannerImageView)

        profileDetailHeaderView.alpha = 1.0
        profileDetailHeaderView.backgroundColor = UIColor.whiteColor()

        // Set the scroll view settings
        profileDetailNameAndLocationScrollView.scrollEnabled = true
        profileDetailNameAndLocationScrollView.pagingEnabled = true
        profileDetailNameAndLocationScrollView.contentSize = CGSizeMake(width*2, 165)
        profileDetailNameAndLocationScrollView.showsHorizontalScrollIndicator = false
        profileDetailNameAndLocationScrollView.showsVerticalScrollIndicator = false
        
        profileDetailThumbImageCenter = profileDetailThumbImageView.center
        profileDetailNameCenter = profileDetailNameLabel.center
        profileDetailHandleCenter = profileDetailHandleLabel.center
        profileDetailTweetsCountCenter = profileDetailTweetsCountLabel.center
        profileDetailFollowersCountCenter = profileDetailFollowersCountLabel.center
        profileDetailFollowingCountCenter = profileDetailFollowingCountLabel.center
        profileDetailTweetsLabelCenter = profileDetailTweetsLabel.center
        profileDetailFollowersLabelCenter = profileDetailFollowersLabel.center
        profileDetailFollowingLabelCenter = profileDetailFollowingLabel.center
        profileDetailHeaderLineCenter = profileDetailHeaderLineView.center
        profileDetailHeaderViewFrame = profileDetailHeaderView.frame
        profileDetailBannerImageViewFrame = profileDetailBannerImageView.frame

    }
    


    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var rect = self.profileDetailHeaderView.frame
        var contentOffset = self.profileTableView.contentOffset.y
        NSLog("Scroll view contentoffset: \(contentOffset) and rectOrigin y :  \(rect.origin.y )")
        let width = view.frame.width

        //self.profileDetailHeaderView.transform = CGAffineTransformMakeScale(1, 1 - contentOffset/60)
        if contentOffset > 0  && contentOffset < width - 100 {
            self.profileDetailThumbImageView.center.x = width/2 - contentOffset/2
            NSLog("In first section \(self.profileTableView.frame.height) and original frame height \(profileTableViewFrame.height)")
            if (blurEffectAdded) {
                blurEffectAdded = false
                UIView.animateWithDuration(0.5, animations: {
                    self.visualEffectView.removeFromSuperview()
                })
            }
        }
        
        if contentOffset > width - 100  && contentOffset < width + 30  {
            if (blurEffectAdded == false) {
                blurEffectAdded = true
                UIView.animateWithDuration(0.5, animations: {
                    self.profileDetailBannerImageView.addSubview(self.visualEffectView)
                })
            }
            self.profileDetailNameLabel.center.y = self.profileDetailNameCenter.y - (contentOffset - width + 100)/2
            self.profileDetailHandleLabel.center.y = self.profileDetailHandleCenter.y - (contentOffset - width + 100)/2
            
            self.profileDetailTweetsCountLabel.center.y = self.profileDetailTweetsCountCenter.y - (contentOffset - width + 100)/2
            self.profileDetailTweetsLabel.center.y = self.profileDetailTweetsLabelCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowersCountLabel.center.y = self.profileDetailFollowersCountCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowersLabel.center.y = self.profileDetailFollowersLabelCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowingCountLabel.center.y = self.profileDetailFollowingCountCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowingLabel.center.y = self.profileDetailFollowingLabelCenter.y - (contentOffset - width + 100)/2
            self.profileDetailHeaderLineView.center.y = self.profileDetailHeaderLineCenter.y - (contentOffset - width + 100)/2

            self.profileTableView.frame = CGRect(x: 0, y: profileTableViewFrame.origin.y - (contentOffset - width + 100)/2, width: width, height: profileTableViewFrame.height + (contentOffset - width + 100)/2)
            self.profileDetailHeaderView.frame = CGRect(x: profileDetailHeaderViewFrame.origin.x, y: profileDetailHeaderViewFrame.origin.y, width: width, height: profileDetailHeaderViewFrame.height - (contentOffset - width + 100)/2)
            self.profileDetailBannerImageView.frame = CGRect(x: profileDetailBannerImageViewFrame.origin.x, y: profileDetailBannerImageViewFrame.origin.y, width: width, height: profileDetailBannerImageViewFrame.height - (contentOffset - width + 100)/2)
            visualEffectView.frame = profileDetailBannerImageView.bounds
//            self.profileDetailBannerImageView.alpha = 1 - (contentOffset - width + 100)/260
  //          self.profileDetailBannerImageView.opaque = true
            NSLog(" in Second section \(self.profileTableView.frame.height) and original frame height \(profileTableViewFrame.height)")


        }

        if contentOffset > width + 30  && contentOffset < width + 150  {
            
            self.profileDetailTweetsCountLabel.center.y = self.profileDetailTweetsCountCenter.y - (contentOffset - width + 100)/2
            self.profileDetailTweetsLabel.center.y = self.profileDetailTweetsLabelCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowersCountLabel.center.y = self.profileDetailFollowersCountCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowersLabel.center.y = self.profileDetailFollowersLabelCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowingCountLabel.center.y = self.profileDetailFollowingCountCenter.y - (contentOffset - width + 100)/2
            self.profileDetailFollowingLabel.center.y = self.profileDetailFollowingLabelCenter.y - (contentOffset - width + 100)/2
            self.profileDetailHeaderLineView.center.y = self.profileDetailHeaderLineCenter.y - (contentOffset - width + 100)/2
            
            self.profileTableView.frame = CGRect(x: 0, y: profileTableViewFrame.origin.y - (contentOffset - width + 100)/2, width: width, height: profileTableViewFrame.height + (contentOffset - width + 100)/2)
            self.profileDetailHeaderView.frame = CGRect(x: profileDetailHeaderViewFrame.origin.x, y: profileDetailHeaderViewFrame.origin.y, width: width, height: profileDetailHeaderViewFrame.height - (contentOffset - width + 100)/2)
            
        }

        var velocity = scrollView.panGestureRecognizer.velocityInView(view)

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 215
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)

        if self.user == nil {
            self.user = User.currentUser
            homeButton.title = ""
            homeButton.image = UIImage(named: "hamburger.png")
            profileView = true
        } else {
            homeButton.enabled = true
        }

        self.createProfileDetailHeaderView()
        // Do any additional setup after loading the view.
        if let profileBannerUrl = self.user!.backgroundImageUrl {
            profileDetailBannerImageView.setImageWithURL(NSURL(string: profileBannerUrl))
        } else {
            profileDetailBannerImageView.setImageWithURL(NSURL(string: "http://a0.twimg.com/images/themes/theme19/bg.gif"))
        }
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
        
        visualEffectView.frame = profileDetailBannerImageView.bounds

        profileDetailThumbImageView.setImageWithURL(NSURL(string: self.user!.profileImageUrl!))
        profileDetailThumbImageView.layer.cornerRadius = 5;
        profileDetailThumbImageView.clipsToBounds = true;

        profileDetailTweetsCountLabel.text = "100"
        profileDetailFollowersCountLabel.text = "15666"
        profileDetailFollowingCountLabel.text = "124"




        profileDetailNameLabel.text = self.user!.name!
        profileDetailHandleLabel.text = "@\(self.user!.screenName!)"
        profileDetailLocationLabel.text = self.user!.location!
        profileDetailTaglineLabel.text = self.user!.tagLine!
        profileDetailTweetsCountLabel.text = "\(self.user!.numberOfTweets!)"
        profileDetailFollowersCountLabel.text = "\(self.user!.numberOfFollowers!)"
        profileDetailFollowingCountLabel.text = "\(self.user!.numberFollowing!)"

        
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        
        self.view.addSubview(profileDetailHeaderView)
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 40.0;
        profileTableViewFrame = profileTableView.frame

        Tweet.getUserTimeline(user!.screenName!, completion: {(tweets: [Tweet]?, error: NSError?) -> Void in
            if (tweets != nil) {
                self.tweets = tweets!
                self.profileTableView.reloadData()
                self.profileTableViewFrame = self.profileTableView.frame
            } else {
                println("Failed to get the tweets \(error!)")
            }
        })
        let width = view.frame.width
        //profileDetailScrollHeaderView.contentSize = CGSizeMake(width*2, 215)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell1") as TweetCell
        cell.indexPathRow = indexPath.row
        cell.tweet = tweets[indexPath.row]
        
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
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
