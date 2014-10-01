//
//  CreateTweetViewController.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit
import AVFoundation

protocol TweetCreateViewControllerDelegate {
    func onNewTweet(tweet:Tweet)
}


class CreateTweetViewController: UIViewController, UITextViewDelegate {

    var replyToTweet: Tweet?
    var delegate : TweetCreateViewControllerDelegate?

    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileThumbView: UIImageView!

    @IBOutlet weak var tweetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var whatsHapenningLabel: UILabel!
    
    var tweetBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("up", ofType: "wav")!)
    var tweetBeepAudioPlayer = AVAudioPlayer()


    @IBAction func onTweet(sender: AnyObject) {
        var text = tweetTextView.text
        var inReplyToTweetId: String? = nil
        if let inReplyToTweet = replyToTweet {
            inReplyToTweetId = inReplyToTweet.id
        }
        Tweet.newTweet(text, inReplyToTweetId: inReplyToTweetId) { (tweet, error) -> () in
            if (error != nil) {
                println("error while Tweeting! \(error)")
                // TODO show error alert view
            } else {
                println("Tweeted!!!!!! \(tweet)")
                NSNotificationCenter.defaultCenter().postNotificationName("NewTweetCreated", object: tweet)

                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    
    @IBAction func onCancel(sender: AnyObject) {
        tweetTextView.endEditing(true)

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = User.currentUser
        self.tweetTextView.delegate = self
        nameLabel.text = currentUser?.name
        handleLabel.text = currentUser?.screenName
        profileThumbView.setImageWithURL(NSURL(string: currentUser!.profileImageUrl!))
        profileThumbView.layer.cornerRadius = 5;
        profileThumbView.clipsToBounds = true;
        tweetBarButtonItem.enabled = false
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        self.navigationItem.title = "Tweet"

        var replyMentionsText = ""
        if let tweet = replyToTweet {
            whatsHapenningLabel.hidden = true
            self.navigationItem.title = "Reply"
            replyMentionsText += "@\(tweet.user!.screenName!) "
            var mentions: [NSDictionary] = tweet.entities!["user_mentions"] as [NSDictionary]
            for mention in mentions {
                var mentionScreenName = mention["screen_name"] as String
                replyMentionsText += "@\(mentionScreenName) "
            }
            tweetTextView.text = replyMentionsText
            var count = countElements(replyMentionsText)
            characterCount.text = "\(140 - count)"
            tweetBarButtonItem.enabled = true
        } else {
            // Set the default text
            characterCount.text = "140"
        }
        tweetTextView.userInteractionEnabled = true
        tweetTextView.editable = true
        
        tweetBeepAudioPlayer = AVAudioPlayer(contentsOfURL: tweetBeep, error: nil)
        tweetBeepAudioPlayer.prepareToPlay()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        tweetTextView.becomeFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        whatsHapenningLabel.hidden = true
        var text = textView.text!
        var count = countElements(text)
        characterCount.text = "\(140 - count)"
        if (count == 0) {
            tweetBarButtonItem.enabled = false
        } else {
            tweetBarButtonItem.enabled = true
        }
        
        if (count > 140) {
            tweetBarButtonItem.enabled = false
            characterCount.textColor = UIColor.redColor()
        } else {
            tweetBarButtonItem.enabled = true
            characterCount.textColor = UIColor(white: 0.5, alpha: 1.0)
        }
        
    }

    func textViewDidBeginEditing(textView: UITextView) {

    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            whatsHapenningLabel.hidden = false
        }
        textView.resignFirstResponder();
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
