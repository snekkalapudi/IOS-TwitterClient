//
//  TwitterLoginViewController.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class TwitterLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                // perform seque
                self.performSegueWithIdentifier("homeSegue", sender: self)
            } else {
                // handle login error
            }
            
        }
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
