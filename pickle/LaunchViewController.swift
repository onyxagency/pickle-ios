//
//  LaunchViewController.swift
//  pickle
//
//  Created by Zach Nolan on 9/16/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit

func delay(delay:Double, closure:()->()) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      delay(1) {
        
        self.performSegueWithIdentifier("showMenu", sender: nil)
        
      }
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
