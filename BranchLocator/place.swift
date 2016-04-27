//
//  place.swift
//  BranchLocator
//
//  Created by Tim Choo on 4/25/16.
//  Copyright © 2016 Tim Choo. All rights reserved.
//

import Foundation
import MapKit

class place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }

}
