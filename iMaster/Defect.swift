//
//  Defect.swift
//  iMaster
//
//  Created by Mikhail Volkov on 20.02.15.
//  Copyright (c) 2015 imsut. All rights reserved.
//

import Foundation

class Defect
{
    var type: String
    var date: String
    var imageURL: String
    var mapImageURL: String
    var longitude: String
    var latitude: String
    //var done: String
    
    init(type: String, date: String, imageURL: String, mapImageURL: String, longitude: String, latitude: String) {
        self.type = type
        self.date = date
        self.imageURL = imageURL
        self.mapImageURL = mapImageURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    class func defectsWithJSON(allResults: NSArray) -> [Defect] {
        
        // Create an empty array of Albums to append to from this list
        var defects = [Defect]()
        
        // Store the results in our table data array
        if allResults.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                
                var type = result["Type"] as? String
                if type == nil {
                    type = result["Date"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var date = result["Date"] as? String
                let imageURL = result["URL"] as? String ?? ""
                let longitude = result["Longitude"] as? String ?? ""
                let latitude = result["Latitude"] as? String ?? ""
                
                
                let mapImageURL =  "http://static-maps.yandex.ru/1.x/?ll=" + longitude + "," + latitude + "&size=568,337&z=13&l=map&pt=" + longitude + "," + latitude// + ",pmwtm99"
                
                
                
                //37.620070,55.753630& result["artworkUrl100"] as? String ?? ""
                
                
           //     http://static-maps.yandex.ru/1.x/?ll=37.620070,55.753630& \
           //     size=450,450&z=13&l=map&pt=37.620070,55.753630,pmwtm1~37.64,55.76363, \
           //     pmwtm99
                
                
                
                var newDefect = Defect(type: type!, date: date!, imageURL: imageURL, mapImageURL: mapImageURL, longitude: longitude, latitude: latitude)
                defects.append(newDefect)
            }
        }
        return defects
    }

}