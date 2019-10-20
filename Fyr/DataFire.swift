//
//  DataFire.swift
//  NasaApp
//
//  Created by Maykon Meneghel on 19/10/19.
//  Copyright © 2019 Maykon Meneghel. All rights reserved.
//

import Foundation

class DataFire: Codable{
    internal init(acq_date: String, acq_time: String, bright_ti4: String, bright_ti5: String, confidence: String, daynight: String, frp: String, latitude: String, longitude: String, satellite: String, scan: String, track: String, version: String) {
        self.acq_date = acq_date
        self.acq_time = acq_time
        self.bright_ti4 = bright_ti4
        self.bright_ti5 = bright_ti5
        self.confidence = confidence
        self.daynight = daynight
        self.frp = frp
        self.latitude = latitude
        self.longitude = longitude
        self.satellite = satellite
        self.scan = scan
        self.track = track
        self.version = version
    }
    
    var acq_date: String
    var acq_time: String
    var bright_ti4: String
    var bright_ti5: String
    var confidence: String
    var daynight: String
    var frp: String
    var latitude: String
    var longitude: String
    var satellite: String
    var scan: String
    var track: String
    var version: String
}
