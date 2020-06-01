//
//  LaureateCellViewModel.swift
//  NobelLaureates
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class LaureateCellViewModel: NSObject {
    var fullName: String
    var year: Int
    var city: String
    var lat: Double
    var lng: Double
    
    init(_ laureate: Laureate) {
        fullName = "\(laureate.firstName) \(laureate.lastName)"
        year = Int(laureate.year) ?? 0
        city = laureate.city
        lat = laureate.location.lat
        lng = laureate.location.lng
    }
}
