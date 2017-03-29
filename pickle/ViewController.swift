//
//  ViewController.swift
//  pickle
//
//  Created by Zach Nolan on 3/5/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit
import CoreLocation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


var places = [Dictionary<String, String>()]
var locationUser = [String:CLLocationDegrees]()
var friendlyLocation = ""

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
  
  var manager:CLLocationManager!
  
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  func displayAlert(_ title:String, error:String) {
    
    let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      
      self.continueBtn.setTitle("Continue", for: UIControlState())
      self.continueArrow.isHidden = false
      self.menuBar.backgroundColor = colorWithHexString("026F5A")
      
      let backgroundImage = UIImage(named: "menu-background.jpg")
      UIView.transition(with: self.backgroundImage,
        duration: 0.3,
        options: .transitionCrossDissolve,
        animations: { self.backgroundImage.image = backgroundImage },
        completion: nil)
      
      self.line.isHidden = false
      self.currentLocationImage.isHidden = false
      self.location.isHidden = false
      self.breakfast.isHidden = false
      self.lunch.isHidden = false
      self.dinner.isHidden = false
      
    }))
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  var currentLocation = CLLocation()
  
  @IBAction func currentLocation(_ sender: AnyObject) {
    
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
  @IBOutlet var menuBar: UIView!
  @IBOutlet var backgroundImage: UIImageView!
  @IBOutlet var line: UIView!
  @IBOutlet var currentLocationImage: UIImageView!
  
  @IBAction func locationChanged(_ sender: AnyObject) {
    setContinueBtn()
  }
  
  var mealType = ""
  
  func setContinueBtn() {
    if (mealType != "" && location.text?.characters.count >= 3) {
      self.continueBtn.alpha = 1
      self.continueBtn.isEnabled = true
      self.continueArrow.alpha = 1
    }
  }
  
  @IBAction func breakfast(_ sender: AnyObject) {
    self.breakfast.alpha = 1
    self.lunch.alpha = 0.5
    self.dinner.alpha = 0.5
    mealType = "breakfast"
    setContinueBtn()
  }
  
  @IBAction func lunch(_ sender: AnyObject) {
    self.breakfast.alpha = 0.5
    self.lunch.alpha = 1
    self.dinner.alpha = 0.5
    mealType = "lunch"
    setContinueBtn()
  }
  
  @IBAction func dinner(_ sender: AnyObject) {
    self.breakfast.alpha = 0.5
    self.lunch.alpha = 0.5
    self.dinner.alpha = 1
    mealType = "dinner"
    setContinueBtn()
  }
  
  var userLocation = ""
  
  @IBAction func getFood(_ sender: AnyObject) {
    
    var errorMessage = ""
    
    if location.text != "Current Location" {
      
      userLocation = location.text!
      friendlyLocation = location.text!
      
    }
    
    if userLocation == "" {
      errorMessage = "Please enter a location"
    }
    
    if errorMessage != "" {
      
      displayAlert("Stuck in a Pickle", error: errorMessage)
      
    } else {
      
      continueBtn.setTitle("Loading...", for: UIControlState())
      continueArrow.isHidden = true
      menuBar.backgroundColor = UIColor.clear.withAlphaComponent(0)
      
      let darkBackgroundImage = UIImage(named: "dark-menu-background.jpg")
      UIView.transition(with: self.backgroundImage,
        duration: 0.3,
        options: .transitionCrossDissolve,
        animations: { self.backgroundImage.image = darkBackgroundImage },
        completion: nil)
      
      line.isHidden = true
      currentLocationImage.isHidden = true
      location.isHidden = true
      breakfast.isHidden = true
      lunch.isHidden = true
      dinner.isHidden = true
      
      UIApplication.shared.beginIgnoringInteractionEvents()
    
      var request = URLRequest(url:URL(string: "http://pickle.onyxla.co/search")!)
      //var request = NSMutableURLRequest(url: URL(string: "http://pickle.onyxla.co/search")!)
      let session = URLSession.shared
    
      let params = ["location":userLocation, "term":mealType] as Dictionary
    
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
      } catch {
        print(error)
        request.httpBody = nil
      }
    
      let task = session.dataTask(with: request, completionHandler: { data, response, error in
        
        guard data != nil else {
          print("no data found: \(error)")
          DispatchQueue.main.async {
            
            self.displayAlert("Oops!", error: "We couldn't connect to the server")
            
          }
          return
        }
        
        do {
          
          if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
            
            if let businesses = json["businesses"] as? [[String:Any]]  {
            
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

                  var category = ""
                  if let categoriesArray = business["categories"] as? NSArray {
                    if categoriesArray.count > 0 {
                      if let categoryArray = categoriesArray[0] as? NSArray {
                        if categoryArray.count > 0 {
                          category = categoryArray[0] as! String
                        }
                      }
                    }
                  }
                  
                  var address = ""
                  let locationArray = business["location"] as! NSDictionary
                  
                  if let addressArray = locationArray["address"] as? NSArray {
                    if addressArray.count > 0 {
                      address = addressArray[0] as! String
                    } else if let displayAddressArray = locationArray["display_address"] as? NSArray {
                      if displayAddressArray.count > 0 {
                        address = displayAddressArray[0] as! String
                      }
                    }
                  }
                  
                  let coordinateArray = locationArray["coordinate"] as! NSDictionary
                  
                  let latitude = coordinateArray["latitude"]! as! Double
                  let lat = latitude.description
                  
                  let longitude = coordinateArray["longitude"]! as! Double
                  let long = longitude.description
                  
                  var rating = ""
                  if (business["rating_img_url"] as? String != nil) {
                    rating = business["rating_img_url"] as! String
                  }
                  
                  var mobileURL = ""
                  if (business["mobile_url"] as? String != nil) {
                    mobileURL = business["mobile_url"] as! String
                  }
                    
                  places.append(["name":name, "imageUrl":imageURL, "category":category, "address":address, "phone":phone, "rating":rating, "latitude":lat, "longitude":long, "selected":"false", "mobileUrl": mobileURL])
                  
                }
                
                DispatchQueue.main.async {
                  
                  UIApplication.shared.endIgnoringInteractionEvents()
                  
                  self.performSegue(withIdentifier: "showPlaces", sender: nil)
                  
                }
                
              } else {
                
                DispatchQueue.main.async {
                  
                  self.displayAlert("Oops!", error: "We couldn't find any results for your location, please try again.")
                  
                }
                
              }
              
            } else {
              
              DispatchQueue.main.async {
                
                UIApplication.shared.endIgnoringInteractionEvents()
                
                self.displayAlert("Oops!", error: "We couldn't find any results for your location, please try again.")
                
              }
              
            }
            
          } else {
            
            DispatchQueue.main.async {
              
              self.displayAlert("Oops!", error: "We couldn't connect to the server, please try again later.")
              
            }
            
          }
          
        } catch let parseError {
          print(parseError)
          let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
          print("Error could not parse JSON: '\(jsonStr)'")
        }
        
      }) 
    
      task.resume()
      
    }
    
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
      
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
            
            print(error!)
            
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
              
              friendlyLocation = city
              
              self.location.text = "Current Location"
              
              self.setContinueBtn()
              
            }
            
          }
          
        })

        
      } else {
        
        print("location is nil")
        
      }
      
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.isNavigationBarHidden = true
    places.removeAll(keepingCapacity: true)
    
    self.continueBtn.setTitle("Continue", for: UIControlState())
    self.continueArrow.isHidden = false
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    if places.count == 1 {
      places.remove(at: 0)
    }
    
    self.continueBtn.isEnabled = false
    
    self.location.delegate = self
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }

}

