//
//  TableViewController.swift
//  pickle
//
//  Created by Zach Nolan on 3/5/15.
//  Copyright (c) 2015 Onyx. All rights reserved.
//

import UIKit

var placeCount = 0

class TableViewController: UITableViewController {
  
  @IBOutlet var pickleButton: UIBarButtonItem!
  
  @IBAction func pickleAll(sender: AnyObject) {
    
    navigationItem.title = ""
    
    performSegueWithIdentifier("showResult", sender: nil)
    
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    //register custom cell
    let nib = UINib(nibName: "vwTblCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }

  override func numberOfSectionsInTableView(tableView: (UITableView!)) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
      return 1
  }

  override func tableView(tableView: (UITableView!), numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      return places.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell:TblCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! TblCell
    
    self.configureCell(cell, atIndexPath: indexPath)
    
    return cell
  }

  func configureCell(cell: TblCell, atIndexPath indexPath: NSIndexPath) {
    
    cell.placeName.text = places[indexPath.row]["name"]
    
    cell.placeCategory.text = places[indexPath.row]["category"]
    
    cell.placeAddress.text = places[indexPath.row]["address"]
    
    let url = NSURL(string: places[indexPath.row]["imageUrl"]!)
    
    let urlRequest = NSURLRequest(URL: url!)
    
    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
      response, data, error in
    
      if error != nil {
    
        print("There was an error")
    
      } else {
    
        let image = UIImage(data: data!)
    
        cell.placeImage.image = image
            
      }
          
    })
    
    if (places[indexPath.row]["selected"] == "true") {
      
      cell.backgroundColor = UIColor.blueColor()
      
    } else {
      
      cell.backgroundColor = UIColor.whiteColor()
      
    }
    
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if places[indexPath.row]["selected"] == "true" {
      
      places[indexPath.row]["selected"] = "false"
      placeCount--
      
    } else {
    
      places[indexPath.row]["selected"] = "true"
      placeCount++
      
    }
    
    if placeCount <= 0 {
      
      pickleButton.title = "Pickle All"
      
    } else {
      
      pickleButton.title = "Pickle \(placeCount)"
      
    }
    
    tableView.reloadData()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    
    self.navigationItem.title = "Select Places"
    self.navigationController?.navigationBarHidden = false
    self.navigationController?.setToolbarHidden(false, animated: true)
    self.navigationController?.toolbar.barTintColor = UIColor.whiteColor()

  }
  
  override func viewWillDisappear(animated: Bool) {
    
    self.navigationController?.setToolbarHidden(true, animated: true)
    
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 120
  }

}
