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

func getDataFromURL(url:NSURL, completion: ((data: NSData?) -> Void)) {
  NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
    completion(data: data)
  }.resume()
}

func downloadImage(url:NSURL, image:UIImageView) {
  getDataFromURL(url) { data in
    dispatch_async(dispatch_get_main_queue()) {
      image.image = UIImage(data: data!)
    }
  }
}

func colorWithHexString (hex:String) -> UIColor {
  var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
  
  if (cString.hasPrefix("#")) {
    cString = (cString as NSString).substringFromIndex(1)
  }
  
  if (cString.characters.count != 6) {
    return UIColor.grayColor()
  }
  
  let rString = (cString as NSString).substringToIndex(2)
  let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
  let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
  
  var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
  NSScanner(string: rString).scanHexInt(&r)
  NSScanner(string: gString).scanHexInt(&g)
  NSScanner(string: bString).scanHexInt(&b)
  
  return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
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
