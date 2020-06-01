//
//  Constants.swift
//  NobelLaureates
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    static let latitudeLowerBound: Double = -85.0
    static let latitudeUpperBound: Double = 85.0
    static let longitudeLowerBound: Double = -180.0
    static let longitudeUpperBound: Double = 180.0
    static let yearLowerBound: Int = 1900
    static let yearUpperBound: Int = 2020
    static let iosBlueColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    static let jsonFileName = "nobel-prize-laureates"
    static func getYears() -> [Int]{
        var years = [Int]()
        for i in yearLowerBound...yearUpperBound{
            years.append(i)
        }
        return years
    }
}
