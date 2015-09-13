//
//  ViewController.swift
//  iMaster
//
//  Created by Mikhail Volkov on 17.02.15.
//  Copyright (c) 2015 imsut. All rights reserved.
//

import UIKit
//import QuartzCore

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    var refreshControl:UIRefreshControl!
    
   let kCellIdentifier: String = "SearchResultCell"
    var defects = [Defect]()

    @IBAction func refresh(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.loadDefectsList("Twitter")
    }

    @IBOutlet var appsTableView : UITableView?
    var tableData = []
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(NSBundle.mainBundle().bundleIdentifier)
        
        api = APIController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.loadDefectsList("Twitter")
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        appsTableView!.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defects.count
    }
    
   // func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
   //     cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
   //     UIView.animateWithDuration(0.25, animations: {
   //         cell.layer.transform = CATransform3DMakeScale(1,1,1)
   //     })
   // }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let defect = self.defects[indexPath.row]
       
        let dateS = defect.date
        let urlString = defect.imageURL
        let typeString = defect.type
        
        cell.textLabel!.text = dateS
        cell.detailTextLabel?.text = typeString

        cell.imageView?.image = UIImage(named: "Blank52")
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var urlS = "http://mkiit.ru/dep/" + urlString
            let imgURL: NSURL? = NSURL(string: urlS)

            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        //cell.imageView?.image = UIImage(data: imgData!)!
        
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        let selectedDefect = self.defects[indexPath.row]
        
        var alert: UIAlertView = UIAlertView()
        alert.title = selectedDefect.date
        alert.message = selectedDefect.type
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    */

    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["defects"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.defects = Defect.defectsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.refreshControl.endRefreshing()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details"
        {
            var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
            var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
            var selectedAlbum = self.defects[albumIndex]
            detailsViewController.defect = selectedAlbum
        }
        
        if segue.identifier == "map"
        {
            var mapViewController: MapViewController = segue.destinationViewController as MapViewController
            mapViewController.defects = self.defects
        }
        
    }

}

