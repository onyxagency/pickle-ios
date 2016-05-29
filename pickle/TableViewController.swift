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
  
  //@IBOutlet var pickleButton: UIBarButtonItem!
  //@IBOutlet var pickleButton: UIButton!
  
  @IBAction func pickleAll(sender: AnyObject) {
    
    navigationItem.title = ""
    
    performSegueWithIdentifier("showResult", sender: nil)

  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    //register custom cell
    let nib = UINib(nibName: "vwTblCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    
    self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
    self.navigationController?.navigationBar.barTintColor = colorWithHexString("6FD16B")
    
    let navBarFont:AnyObject = UIFont(name: "CircularStd-Book", size: 16)!
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navBarFont]
    
    self.tableView.separatorColor = colorWithHexString("D8D8D8")

    self.tableView.tableFooterView = UIView(frame: CGRectZero)

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
    
    if let ratingURL = NSURL(string: places[indexPath.row]["rating"]!) {
      downloadImage(ratingURL, image: cell.placeRating)
    }
    
    if let imageURL = NSURL(string: places[indexPath.row]["imageUrl"]!) {
      downloadImage(imageURL, image: cell.placeImage)
    }
    
    if (places[indexPath.row]["selected"] == "true") {
      
      cell.backgroundColor = colorWithHexString("EBFFEA")
      UIView.transitionWithView(cell.placeSelectedImage,
        duration: 0.2,
        options: .TransitionCrossDissolve,
        animations: { cell.placeSelectedImage.image = UIImage(named: "selected.png") },
        completion: nil)
      
    } else {
      
      cell.backgroundColor = UIColor.whiteColor()
      UIView.transitionWithView(cell.placeSelectedImage,
        duration: 0.2,
        options: .TransitionCrossDissolve,
        animations: { cell.placeSelectedImage.image = UIImage(named: "unselected.png") },
        completion: nil)
      
    }
    
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCellTableViewCell
    headerCell.backgroundColor = colorWithHexString("F6F6F6")
    return headerCell
  }
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerCell = tableView.dequeueReusableCellWithIdentifier("FooterCell") as! CustomFooterCellTableViewCell
    footerCell.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0)
    if placeCount > 0 {
      footerCell.pickleButton.setTitle("\(placeCount)", forState: .Normal)
      footerCell.pickleButton.setBackgroundImage(UIImage(named: "pickle-button.png"), forState: .Normal)
    }
    return footerCell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if places[indexPath.row]["selected"] == "true" {
      
      places[indexPath.row]["selected"] = "false"
      placeCount -= 1
      
    } else {
    
      places[indexPath.row]["selected"] = "true"
      placeCount += 1
      
    }
    
    tableView.reloadData()
    
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if cell.respondsToSelector(Selector("setSeparatorInset:")) {
      cell.separatorInset = UIEdgeInsetsZero
    }
    if cell.respondsToSelector(Selector("setLayoutMargins:")) {
      cell.layoutMargins = UIEdgeInsetsZero
    }
    if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
      cell.preservesSuperviewLayoutMargins = false
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
    self.navigationItem.title = "Places in \(friendlyLocation)"
    self.navigationController?.navigationBarHidden = false
    placeCount = 0

  }
  
  override func viewWillDisappear(animated: Bool) {
    
    self.navigationController?.navigationBarHidden = true
    
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 93
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 25
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 72
  }

}
