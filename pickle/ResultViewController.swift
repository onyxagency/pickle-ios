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

  @IBOutlet var placeImage: UIImageView!
  @IBOutlet var placeName: UILabel!
  @IBOutlet var placeCategories: UILabel!
  @IBOutlet var leaveTimer: UILabel!
  @IBOutlet var ratingImage: UIImageView!
  @IBOutlet var getDirections: UIButton!
  @IBOutlet var yelpUrl: UIButton!
  //@IBOutlet var distanceLabel: UILabel!
  
  var lat:NSString = ""
  var lng:NSString = ""
  
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
  
  @IBAction func goToYelp(sender: AnyObject) {
    let targetURL = NSURL(string: yelpUrl.currentTitle!)
    let application = UIApplication.sharedApplication()
    application.openURL(targetURL!)
  }
  
  @IBAction func getDirections(sender: AnyObject) {
    
    let latitude:CLLocationDegrees = lat.doubleValue
    let longitude:CLLocationDegrees = lng.doubleValue
    
    let regionDistance:CLLocationDistance = 1000
    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
      MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = placeName.text!
    mapItem.openInMapsWithLaunchOptions(options)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Your Pickle"
    
    getDirections.layer.borderColor = UIColor.whiteColor().CGColor
    
    placeImage.layer.cornerRadius = placeImage.frame.width
    placeImage.clipsToBounds = true
    
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
    
    if let placeImageURL = NSURL(string: resultPlace["imageUrl"]!) {
      downloadImage(placeImageURL, image: placeImage)
    }
      
    placeName.text = resultPlace["name"]
    placeCategories.text = resultPlace["category"]
    
    if let placeRatingURL = NSURL(string: resultPlace["rating"]!) {
      downloadImage(placeRatingURL, image: ratingImage)
    }
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    
    yelpUrl.setTitle(resultPlace["mobileUrl"], forState: .Normal)
    
    lat = resultPlace["latitude"]!
    lng = resultPlace["longitude"]!
    
    // get distance between users location and destination
    
//    if locationUser.count > 0 {
//      
//      let userLocation:CLLocation = CLLocation(latitude: locationUser["latitude"]!, longitude: locationUser["longitude"]!)
//      
//      let destLatitude:Double = NSString(string: resultPlace["latitude"]!).doubleValue
//      let destLat:CLLocationDegrees = destLatitude
//      let destLongitude:Double = NSString(string: resultPlace["longitude"]!).doubleValue
//      let destLong:CLLocationDegrees = destLongitude
//      
//      let destLocation:CLLocation = CLLocation(latitude: destLat, longitude: destLong)
//      
//      let distance:CLLocationDistance = userLocation.distanceFromLocation(destLocation)
//      
//      let df = MKDistanceFormatter()
//      
//      df.unitStyle = .Abbreviated
//      
//      distanceLabel.text = df.stringFromDistance(distance)
//      
//    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
