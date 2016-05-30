//
//  ResultLoadingViewController.swift
//  pickle
//
//  Created by Zach Nolan on 5/29/16.
//  Copyright © 2016 Onyx. All rights reserved.
//

import UIKit

class ResultLoadingViewController: UIViewController {
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    delay(3) {
      print("hello!")
      self.performSegueWithIdentifier("showResult", sender: nil)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}