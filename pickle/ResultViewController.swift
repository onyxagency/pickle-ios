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
  
  var timer = Timer()
  var count = 300
  
  func updateTime() {
    
    count -= 1
    
    if count <= 0 {
      
      leaveTimer.text = "Go!"
      timer.invalidate()
      
    } else {
      
      leaveTimer.text = timeString(count)
      
    }
    
    
  }
  
  func timeString(_ time:Int) -> String {
    
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format:"%2i:%02i",minutes,seconds)
    
  }
  
  @IBAction func goToYelp(_ sender: AnyObject) {
    let targetURL = URL(string: yelpUrl.currentTitle!)
    let application = UIApplication.shared
    application.openURL(targetURL!)
  }
  
  @IBAction func getDirections(_ sender: AnyObject) {
    
    let latitude:CLLocationDegrees = lat.doubleValue
    let longitude:CLLocationDegrees = lng.doubleValue
    
    let regionDistance:CLLocationDistance = 1000
    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
      MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = placeName.text!
    mapItem.openInMaps(launchOptions: options)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Your Pickle"
    
    getDirections.layer.borderColor = UIColor.white.cgColor
    
    placeImage.layer.cornerRadius = placeImage.frame.width / 2
    placeImage.clipsToBounds = true
    
    var resultPlaces = places
    
    if placeCount > 0 {
      
      for index in stride(from: (resultPlaces.count - 1), through: 0, by: -1) {
        
        if resultPlaces[index]["selected"]! == "false" {
          
          resultPlaces.remove(at: index)
          
        }
        
      }
      
    }
     
    let randomIndex = Int(arc4random_uniform(UInt32(resultPlaces.count)))
    
    let resultPlace = resultPlaces[randomIndex]
    
    if let placeImageURL = URL(string: resultPlace["imageUrl"]!) {
      downloadImage(placeImageURL, image: placeImage)
    }
      
    placeName.text = resultPlace["name"]
    placeCategories.text = resultPlace["category"]
    
    if let placeRatingURL = URL(string: resultPlace["rating"]!) {
      downloadImage(placeRatingURL, image: ratingImage)
    }
    
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ResultViewController.updateTime), userInfo: nil, repeats: true)
    
    yelpUrl.setTitle(resultPlace["mobileUrl"], for: UIControlState())
    
    lat = resultPlace["latitude"]! as NSString
    lng = resultPlace["longitude"]! as NSString
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
