//
//  ResultViewController.swift
//  pickle
//
//  Created by Zach Nolan on 4/23/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ResultViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet var placeName: UILabel!
  @IBOutlet var placeCategories: UILabel!
  @IBOutlet var leaveTimer: UILabel!
  @IBOutlet var ratingImage: UIImageView!
  @IBOutlet var distanceLabel: UILabel!
  
  var timer = NSTimer()
  var count = 300
  
  func updateTime() {
    
    count--
    
    if count <= 0 {
      
      leaveTimer.text = "Go!"
      timer.invalidate()
      
    } else {
      
      leaveTimer.text = timeString(count)
      
    }
    
    
  }
  
  func timeString(time:Int) -> String {
    
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format:"%2i:%02i",minutes,seconds)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Your Pickle"
    
    var resultPlaces = places
    
    if placeCount > 0 {
      
      for index in (resultPlaces.count - 1).stride(through: 0, by: -1) {
        
        if resultPlaces[index]["selected"]! == "false" {
          
          resultPlaces.removeAtIndex(index)
          
        }
        
      }
      
    }
     
    let randomIndex = Int(arc4random_uniform(UInt32(resultPlaces.count)))
    
    let resultPlace = resultPlaces[randomIndex]
      
    placeName.text = resultPlace["name"]
    placeCategories.text = resultPlace["category"]
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    
    let url = NSURL(string: resultPlace["rating"]!)
    
    let urlRequest = NSURLRequest(URL: url!)
    
    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
        response, data, error in
      
        if error != nil {
        
          print("There was an error")
        
        } else {
        
          let image = UIImage(data: data!)
        
          self.ratingImage.image = image
        
        }
      
      })
    
    // get distance between users location and destination
    
    let userLocation:CLLocation = CLLocation(latitude: locationUser["latitude"]!, longitude: locationUser["longitude"]!)
    
    let destLatitude:Double = NSString(string: resultPlace["latitude"]!).doubleValue
    let destLat:CLLocationDegrees = destLatitude
    let destLongitude:Double = NSString(string: resultPlace["longitude"]!).doubleValue
    let destLong:CLLocationDegrees = destLongitude
    
    let destLocation:CLLocation = CLLocation(latitude: destLat, longitude: destLong)
    
    let distance:CLLocationDistance = userLocation.distanceFromLocation(destLocation)
    
    let df = MKDistanceFormatter()
    
    df.unitStyle = .Abbreviated
    
    distanceLabel.text = df.stringFromDistance(distance)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
