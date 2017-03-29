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
  
  @IBAction func pickleAll(_ sender: AnyObject) {
    
    navigationItem.title = ""
    
    performSegue(withIdentifier: "showResult", sender: nil)

  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    //register custom cell
    let nib = UINib(nibName: "vwTblCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "cell")
    
    self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
    self.navigationController?.navigationBar.barTintColor = colorWithHexString("6FD16B")
    
    let navBarFont:AnyObject = UIFont(name: "CircularStd-Book", size: 16)!
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navBarFont]
    
    self.tableView.separatorColor = colorWithHexString("D8D8D8")

    self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }

  override func numberOfSections(in tableView: (UITableView!)) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
      return 1
  }

  override func tableView(_ tableView: (UITableView!), numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      return places.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell:TblCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TblCell
    
    self.configureCell(cell, atIndexPath: indexPath)
    
    return cell
  }

  func configureCell(_ cell: TblCell, atIndexPath indexPath: IndexPath) {
    
    cell.placeName.text = places[indexPath.row]["name"]
    
    cell.placeCategory.text = places[indexPath.row]["category"]
    
    cell.placeAddress.text = places[indexPath.row]["address"]
    
    if let ratingURL = URL(string: places[indexPath.row]["rating"]!) {
      downloadImage(ratingURL, image: cell.placeRating)
    }
    
    if let imageURL = URL(string: places[indexPath.row]["imageUrl"]!) {
      downloadImage(imageURL, image: cell.placeImage)
    }
    
    if (places[indexPath.row]["selected"] == "true") {
      
      cell.backgroundColor = colorWithHexString("EBFFEA")
      UIView.transition(with: cell.placeSelectedImage,
        duration: 0.2,
        options: .transitionCrossDissolve,
        animations: { cell.placeSelectedImage.image = UIImage(named: "selected.png") },
        completion: nil)
      
    } else {
      
      cell.backgroundColor = UIColor.white
      UIView.transition(with: cell.placeSelectedImage,
        duration: 0.2,
        options: .transitionCrossDissolve,
        animations: { cell.placeSelectedImage.image = UIImage(named: "unselected.png") },
        completion: nil)
      
    }
    
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderCellTableViewCell
    headerCell.backgroundColor = colorWithHexString("F6F6F6")
    return headerCell
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerCell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! CustomFooterCellTableViewCell
    footerCell.backgroundColor = UIColor.clear.withAlphaComponent(0)
    if placeCount > 0 {
      footerCell.pickleButton.setTitle("\(placeCount)", for: UIControlState())
      footerCell.pickleButton.setBackgroundImage(UIImage(named: "pickle-button.png"), for: UIControlState())
    }
    return footerCell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if places[indexPath.row]["selected"] == "true" {
      
      places[indexPath.row]["selected"] = "false"
      placeCount -= 1
      
    } else {
    
      places[indexPath.row]["selected"] = "true"
      placeCount += 1
      
    }
    
    tableView.reloadData()
    
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
      cell.separatorInset = UIEdgeInsets.zero
    }
    if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
      cell.layoutMargins = UIEdgeInsets.zero
    }
    if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
      cell.preservesSuperviewLayoutMargins = false
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationItem.title = "Places in \(friendlyLocation)"
    self.navigationController?.isNavigationBarHidden = false
    placeCount = 0

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    self.navigationController?.isNavigationBarHidden = true
    
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 93
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 25
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 72
  }

}
