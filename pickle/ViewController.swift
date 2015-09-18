//
//  ViewController.swift
//  pickle
//
//  Created by Zach Nolan on 3/5/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit
import CoreLocation

var places = [Dictionary<String, String>()]
var locationUser = [String:CLLocationDegrees]()

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  var manager:CLLocationManager!
  
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  func displayAlert(title:String, error:String) {
    
    let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
      
      self.dismissViewControllerAnimated(true, completion: nil)
      
    }))
    
    self.presentViewController(alert, animated: true, completion: nil)
    
  }
  
  var currentLocation = CLLocation()
  
  @IBAction func currentLocation(sender: AnyObject) {
    
    manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    
  }

  @IBOutlet var location: UITextField!
  @IBOutlet var breakfast: UIButton!
  @IBOutlet var lunch: UIButton!
  @IBOutlet var dinner: UIButton!
  @IBOutlet var continueBtn: UIButton!
  @IBOutlet var continueArrow: UIImageView!
  
  @IBAction func locationChanged(sender: AnyObject) {
    setContinueBtn()
  }
  
  var mealType = ""
  
  func setContinueBtn() {
    if (mealType != "" && location.text?.characters.count >= 3) {
      self.continueBtn.alpha = 1
      self.continueBtn.enabled = true
      self.continueArrow.alpha = 1
    }
  }
  
  @IBAction func breakfast(sender: AnyObject) {
    self.breakfast.alpha = 1
    self.lunch.alpha = 0.5
    self.dinner.alpha = 0.5
    mealType = "breakfast"
    setContinueBtn()
  }
  
  @IBAction func lunch(sender: AnyObject) {
    self.breakfast.alpha = 0.5
    self.lunch.alpha = 1
    self.dinner.alpha = 0.5
    mealType = "lunch"
    setContinueBtn()
  }
  
  @IBAction func dinner(sender: AnyObject) {
    self.breakfast.alpha = 0.5
    self.lunch.alpha = 0.5
    self.dinner.alpha = 1
    mealType = "dinner"
    setContinueBtn()
  }
  
  var userLocation = ""
  
  @IBAction func getFood(sender: AnyObject) {
    
    var errorMessage = ""
    
    if location.text != "Current Location" {
      
      userLocation = location.text!
      
    }
    
    if userLocation == "" {
      errorMessage = "Please enter a location"
    }
    
    if errorMessage != "" {
      
      displayAlert("Stuck In A Pickle", error: errorMessage)
      
    } else {
      
      activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
      activityIndicator.center = self.view.center
      activityIndicator.hidesWhenStopped = true
      activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
      view.addSubview(activityIndicator)
      activityIndicator.startAnimating()
      UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    
      let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/search")!)
      let session = NSURLSession.sharedSession()
    
      let params = ["location":userLocation, "term":mealType] as Dictionary
    
      request.HTTPMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
      } catch {
        print(error)
        request.HTTPBody = nil
      }
    
      let task = session.dataTaskWithRequest(request) { data, response, error in
        
        guard data != nil else {
          print("no data found: \(error)")
          dispatch_async(dispatch_get_main_queue()) {
            
            self.displayAlert("Oops!", error: "We couldn't connect to the server")
            
          }
          return
        }
        
        do {
          
          if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
            
            let businesses:NSArray = json["businesses"] as! NSArray
            
            if businesses.count > 0 {
              
              for business in businesses {
                
                var imageURL = ""
                if (business["image_url"] as? String != nil) {
                  imageURL = business["image_url"] as! String
                }
                
                var name = ""
                if (business["name"] as? String != nil) {
                  name = business["name"] as! String
                }
                
                var phone = ""
                if (business["display_phone"] as? String != nil) {
                  phone = business["display_phone"] as! String
                }

                let categoriesArray = business["categories"] as! NSArray
                let categoryArray = categoriesArray[0] as! NSArray
                let category = categoryArray[0] as! String
                
                let locationArray = business["location"] as! NSDictionary
                let addressArray = locationArray["address"] as! NSArray
                let address = addressArray[0] as! String
                
                let coordinateArray = locationArray["coordinate"] as! NSDictionary
                
                let latitude = coordinateArray["latitude"]! as! Double
                let lat = latitude.description
                
                let longitude = coordinateArray["longitude"]! as! Double
                let long = longitude.description
                
                let rating = business["rating_img_url"] as! String
                  
                places.append(["name":name, "imageUrl":imageURL, "category":category, "address":address, "phone":phone, "rating":rating, "latitude":lat, "longitude":long, "selected":"false"])
                
              }
              
              dispatch_async(dispatch_get_main_queue()) {
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                self.performSegueWithIdentifier("showPlaces", sender: nil)
                
              }
              
            } else {
              
              dispatch_async(dispatch_get_main_queue()) {
                
                self.displayAlert("Oops!", error: "We couldn't find any results for your location, please try again")
                
              }
              
            }
            
          } else {
            
            dispatch_async(dispatch_get_main_queue()) {
              
              self.displayAlert("Oops!", error: "We couldn't find any results for your location, please try again")
              
            }
            
          }
          
        } catch let parseError {
          print(parseError)
          let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
          print("Error could not parse JSON: '\(jsonStr)'")
        }
        
      }
    
      task.resume()
      
    }
    
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
      
      if manager.location != nil {
        
        currentLocation = locations[0] as CLLocation
        let latitude:CLLocationDegrees = currentLocation.coordinate.latitude
        let longitude:CLLocationDegrees = currentLocation.coordinate.longitude
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        
        locationUser["latitude"] = latitude
        locationUser["longitude"] = longitude
        
        manager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
          
          if error != nil {
            
            print(error)
            
          } else {
            
            if let validPlacemark = placemarks?[0] {
              
              let p = validPlacemark as CLPlacemark
            
              var streetNumber = ""
              var street = ""
              var city = ""
              
              if ((p.subThoroughfare) != nil) {
                streetNumber = p.subThoroughfare!
              }
            
              if ((p.thoroughfare) != nil) {
                street = p.thoroughfare!
              }
              
              if ((p.locality) != nil) {
                city = p.locality!
              }
              
              self.userLocation = streetNumber + " " + street + " " + city
              
              self.location.text = "Current Location"
              
            }
            
          }
          
        })

        
      } else {
        
        print("location is nil")
        
      }
      
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    
    self.navigationController?.navigationBarHidden = true
    places.removeAll(keepCapacity: true)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    if places.count == 1 {
      places.removeAtIndex(0)
    }
    
    self.continueBtn.enabled = false
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

