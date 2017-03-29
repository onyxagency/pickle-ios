//
//  LaunchViewController.swift
//  pickle
//
//  Created by Zach Nolan on 9/16/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit

extension Collection where Index == Int {
  /// Return a copy of `self` with its elements shuffled
  func shuffle() -> [Iterator.Element] {
    var list = Array(self)
    list.shuffleInPlace()
    return list
  }
}

extension MutableCollection where Index == Int {
  /// Shuffle the elements of `self` in-place.
  mutating func shuffleInPlace() {
    // empty and single-element collections don't shuffle
    if count < 2 { return }
    
    for i in startIndex ..< endIndex - 1 {
      let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
      if i != j {
        swap(&self[i], &self[j])
      }
    }
  }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func getDataFromURL(_ url:URL, completion: @escaping ((_ data: Data?) -> Void)) {
  URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
    completion(data)
  }) .resume()
}

func downloadImage(_ url:URL, image:UIImageView) {
  getDataFromURL(url) { data in
    DispatchQueue.main.async {
      if data != nil {
        image.image = UIImage(data: data!)
      }
    }
  }
}

func colorWithHexString (_ hex:String) -> UIColor {
  var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
  
  if (cString.hasPrefix("#")) {
    cString = (cString as NSString).substring(from: 1)
  }
  
  if (cString.characters.count != 6) {
    return UIColor.gray
  }
  
  let rString = (cString as NSString).substring(to: 2)
  let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
  let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
  
  var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
  Scanner(string: rString).scanHexInt32(&r)
  Scanner(string: gString).scanHexInt32(&g)
  Scanner(string: bString).scanHexInt32(&b)
  
  return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

class LaunchViewController: UIViewController {
  
  @IBOutlet var p: UILabel!
  @IBOutlet var i: UILabel!
  @IBOutlet var c: UILabel!
  @IBOutlet var k: UILabel!
  @IBOutlet var l: UILabel!
  @IBOutlet var e: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()

    // Animate PICKLE letters
    var pickleLetters = [p, i, c, k, l, e]
    pickleLetters.shuffleInPlace()
    
    UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
      pickleLetters[0]?.alpha = 1
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.75, options: UIViewAnimationOptions.curveEaseIn, animations: {
      pickleLetters[1]?.alpha = 1
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 1, options: UIViewAnimationOptions.curveEaseIn, animations: {
      pickleLetters[2]?.alpha = 1
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 1.25, options: UIViewAnimationOptions.curveEaseIn, animations: {
      pickleLetters[3]?.alpha = 1
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 1.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
      pickleLetters[4]?.alpha = 1
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 1.75, options: UIViewAnimationOptions.curveEaseIn, animations: {
      pickleLetters[5]?.alpha = 1
    }, completion: nil)
    
    
    // After delay go to menu screen
    delay(3) {
      
      self.performSegue(withIdentifier: "showMenu", sender: nil)
      
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
