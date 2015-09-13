//
//  MapViewController.swift
//  iMaster
//
//  Created by Mikhail Volkov on 21.02.15.
//  Copyright (c) 2015 imsut. All rights reserved.
//

import Foundation

import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var defects = [Defect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        var camera = GMSCameraPosition.cameraWithLatitude(55.76, longitude: 37.64, zoom: 9)
        mapView.myLocationEnabled = true
        var i : Int = 0
        mapView.camera = camera
        var markers = [GMSMarker]()
        
        for defect in defects
        {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake((defect.latitude as NSString).doubleValue, (defect.longitude as NSString).doubleValue)
            marker.title = defect.type
            marker.snippet = defect.date
            marker.userData = i
            i++
    
            switch defect.type {
            case "Покрытие":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
            case "Обочина":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
            case "Разметка":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.lightGrayColor())
            case "Водосброс":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            case "Брус":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.cyanColor())
            case "Знак":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            case "Полоса съезда":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
            case "Прочее":
                marker.icon = GMSMarker.markerImageWithColor(UIColor.magentaColor())
            default:
                marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())

            }
            
            marker.map = mapView
            markers.append(marker)
        }
        
        
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool
    {
        self.performSegueWithIdentifier("markerTap", sender: marker)
    
        println(marker.title)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
            var albumIndex = ((sender as GMSMarker).userData as Int) //appsTableView!.indexPathForSelectedRow()!.row
            var selectedAlbum = self.defects[albumIndex]
            detailsViewController.defect = selectedAlbum
    }

    
    
    
}