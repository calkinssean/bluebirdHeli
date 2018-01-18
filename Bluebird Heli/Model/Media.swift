//
//  Media.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/18/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import Foundation

struct Media {
    
    init(url: String, dateString: String, date: Double, type: MediaType, data: Data) {
        self.url = url
        self.dateString = dateString
        self.date = date
        self.mediaType = type
        self.data = data
    }
    
    var url: String
    var dateString: String
    var date: Double
    var mediaType: MediaType
    var data: Data
    
}

enum MediaType {
    case Video
    case Image
}
