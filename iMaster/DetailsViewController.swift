//
//  DetailsViewController.swift
//  iMaster
//
//  Created by Mikhail Volkov on 20.02.15.
//  Copyright (c) 2015 imsut. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var map: UIImageView!
    
    @IBOutlet weak var type: UILabel!
    
    
    var defect: Defect?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.type.text = defect?.type
        //map.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.defect?.mapImageURL)))
        
        
        var url1 = self.defect?.imageURL
        var urlS = "http://mkiit.ru/dep/" + url1!//  urlString
        let imgURL: NSURL? = NSURL(string: urlS)
        map.image = UIImage(data: NSData(contentsOfURL: imgURL!)!)
        
        var urlMapString = self.defect?.mapImageURL
        let imgMapURL: NSURL? = NSURL(string: urlMapString!)
        mapView.image = UIImage(data: NSData(contentsOfURL: imgMapURL!)!)
        
        
        
        /*
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
    }*/
    }
    //yandexnavi://build_route_on_map?lat_to=...&lon_to=...[&lat_from=...][&lon_from=...]
    @IBAction func naviYandex(sender: UIButton) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"yandexnavi://")!)) {
            let lat = self.defect?.latitude
            let lon = self.defect?.longitude
            
            UIApplication.sharedApplication().openURL(NSURL(string:
                "yandexnavi://build_route_on_map?lat_to=\(lat!)&lon_to=\(lon!)")!)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
}