//
//  Capital.swift
//  Project16
//
//  Created by Yurii Sameliuk on 23/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//
import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
