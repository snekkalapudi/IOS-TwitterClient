//
//  TweetCell.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileThumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetHeaderLabel: UILabel!
    @IBOutlet weak var tweetHeaderIconView: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var handleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileThumbViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var profileThumbButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var profileThumbButton: UIButton!

    var parentViewController: TweetsViewController?
    var sb = UIStoryboard(name: "Main", bundle: nil)

    var indexPathRow: Int = -1
    

    var tweet: Tweet! {

        willSet(newTweet) {
            
            self.nameLabel.text = newTweet.user!.name
            self.handleLabel.text = "@\(newTweet.user!.screenName!)"
            self.tweetLabel.text = newTweet.text
            if (newTweet.favoriteCount > 0) {
                self.favoriteCountLabel.hidden = false
                self.favoriteCountLabel.text = "\(newTweet.favoriteCount!)"
            } else {
                self.favoriteCountLabel.hidden = true
            }
            if (newTweet.retweetCount > 0) {
                self.retweetCountLabel.hidden = false
                self.retweetCountLabel.text = "\(newTweet.retweetCount!)"
            } else {
                self.retweetCountLabel.hidden = true
            }

            if let retweetedBy = newTweet.retweetedBy {
                self.tweetHeaderLabel.text = "\(retweetedBy.name!) retweeted"
                self.tweetHeaderLabel.hidden = false
                self.tweetHeaderIconView.hidden = false
                
                handleLabelTopConstraint.constant = 25.0
                profileThumbViewTopConstraint.constant = 25.0
                profileThumbButtonTopConstraint.constant = 25.0
                timeLabelTopConstraint.constant = 25.0
                nameLabelTopConstraint.constant = 24.0

            } else {
                // Fix this to change the height to 0 by changing the constraint
                self.tweetHeaderLabel.hidden = true
                self.tweetHeaderIconView.hidden = true
                handleLabelTopConstraint.constant = 9.0
                profileThumbViewTopConstraint.constant = 9.0
                profileThumbButtonTopConstraint.constant = 9.0
                timeLabelTopConstraint.constant = 9.0
                nameLabelTopConstraint.constant = 8.0

            }
            self.profileThumbView.setImageWithURL(NSURL(string: newTweet.user!.profileImageUrl! as NSString))
            
            profileThumbView.layer.cornerRadius = 5;
            profileThumbView.clipsToBounds = true;
            timeLabel.text = newTweet.userReadableCreatedTime
            
            if (newTweet.retweeted == 1) {
                self.retweetButton.enabled = false
                let image = UIImage(named: "retweet-on.png") as UIImage
                self.retweetButton.setImage(image, forState: UIControlState.Disabled)
            } else {
                self.retweetButton.enabled = true
                let image = UIImage(named: "retweet-light.png") as UIImage
                self.retweetButton.setImage(image, forState: UIControlState.Normal)
            }
            
            if (newTweet.favorited == 1) {
//                self.favoriteButton.enabled = false
                let image = UIImage(named: "favorite-on.png") as UIImage
                self.favoriteButton.setImage(image, forState: UIControlState.Normal)
            } else {
  //              self.favoriteButton.enabled = true
                let image = UIImage(named: "favorite-light.png") as UIImage
                self.favoriteButton.setImage(image, forState: UIControlState.Normal)
            }
            profileThumbButton.imageView?.image = profileThumbView.image

            // These tags will help when the user clicks to figure out what row this belongs to.
            self.replyButton.tag = self.indexPathRow
            self.retweetButton.tag = self.indexPathRow
            self.favoriteButton.tag = self.indexPathRow
            self.profileThumbButton.tag = self.indexPathRow
        }

        didSet(oldValue) {
            
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
