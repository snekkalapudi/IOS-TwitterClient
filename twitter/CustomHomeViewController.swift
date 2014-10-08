//
//  CustomHomeViewController.swift
//  twitter
//
//  Created by Nekkalapudi, Satish on 9/29/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class CustomHomeViewController: UIViewController, ProfileViewControllerDelegate {

    var sb = UIStoryboard(name: "Main", bundle: nil)

    var viewControllers: [String: UIViewController]?

    @IBOutlet weak var sideBarXHorizontalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewXAlignmentConstraint: NSLayoutConstraint!

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var homeTimeLineButton: UIButton!
    @IBOutlet weak var mentionsButton: UIButton!

    @IBOutlet weak var contentView: UIView!


    @IBOutlet var contentViewOnTapGestureRecognizer: UITapGestureRecognizer!
    var sideTrayOpen = false

    @IBOutlet weak var sideBarView: UIView!

    @IBAction func didTapSideBarButton(sender: UIButton) {
        self.sideTrayOpen = false
        self.contentViewOnTapGestureRecognizer.enabled = false
        if sender == homeTimeLineButton {
            homeTimeLineButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            mentionsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            profileButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            NSLog("Home timeline button")
            self.activeViewController = self.viewControllers!["hometimeline"]
        } else if sender == profileButton {
            profileButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            homeTimeLineButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            mentionsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            NSLog("Profile button")
            self.activeViewController = self.viewControllers!["profile"]
        } else if sender == mentionsButton {
            mentionsButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            homeTimeLineButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            profileButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            NSLog("Mentions button")
            self.activeViewController = self.viewControllers!["mentionstimeline"]
        }
        
        UIView.animateWithDuration(0.35, animations: {
            self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.0, 1.0)
            self.contentViewXAlignmentConstraint.constant = 0
            self.sideBarXHorizontalSpaceConstraint.constant = -180
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        if (sideTrayOpen) {
            sideTrayOpen = false
            UIView.animateWithDuration(0.35, animations: {
                self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.0, 1.0)
                self.contentViewXAlignmentConstraint.constant = -180
                self.contentViewXAlignmentConstraint.constant = 0
                self.sideBarXHorizontalSpaceConstraint.constant = -180
                self.view.layoutIfNeeded()
            })
            self.contentViewOnTapGestureRecognizer.enabled = false
        }
    }

    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC =  activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
        
    }

    func hamburgerMenuClicked() {
        self.sideTrayOpen = true
        self.contentViewOnTapGestureRecognizer.enabled = true
        UIView.animateWithDuration(0.35, animations: {
            var rotationAndPerspectiveTransform: CATransform3D = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(-45.0 * M_PI / 180.0), 0.0, 1.0, 0.0);
            //self.contentView.transform = CGAffineTransformMakeScale(0.6, 0.6)
            
            self.contentViewXAlignmentConstraint.constant = -300
            self.sideBarXHorizontalSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.state == .Ended) {
            hamburgerMenuClicked()
        }
    }

    
    @IBAction func didSwipeLeft(sender: UISwipeGestureRecognizer) {
        if (sideTrayOpen) {
            if (sender.state == .Ended) {
                self.sideTrayOpen = false
                self.contentViewOnTapGestureRecognizer.enabled = false
                UIView.animateWithDuration(0.35, animations: {
                    //self.contentView.layer.transform = CATransform3DRotate(self.contentView.layer.transform, CGFloat(45.0 * M_PI / 180.0), 0.0, 1.1, 0.0)
                    
                    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.0, 1.0)
                    self.contentViewXAlignmentConstraint.constant = 0
                    self.sideBarXHorizontalSpaceConstraint.constant = -180
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentViewXAlignmentConstraint.constant = 0
        self.sideBarXHorizontalSpaceConstraint.constant = -180
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 34.0/255.0, green: 75.0/255.0, blue: 89.0/255.0, alpha: 1)

        self.contentViewOnTapGestureRecognizer.enabled = false
        
        var homeTimelineViewController = sb.instantiateViewControllerWithIdentifier("TweetsNavigationViewController") as UIViewController
        var profileViewController = sb.instantiateViewControllerWithIdentifier("ProfileViewNavigationController") as UIViewController
        var profileController = profileViewController.childViewControllers[0] as ProfileViewController
        profileController.delegate = self
        
        var mentionsTimelineViewController = sb.instantiateViewControllerWithIdentifier("TweetsNavigationViewController") as UIViewController
        var vc = mentionsTimelineViewController.childViewControllers[0] as TweetsViewController
        vc.viewMode = "mentions"
        self.viewControllers = ["hometimeline": homeTimelineViewController, "profile": profileViewController, "mentionstimeline": mentionsTimelineViewController]


        self.activeViewController = self.viewControllers!["hometimeline"]
        homeTimeLineButton.setTitleColor(UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
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
