//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by ivan on 2021/10/29.
//

import Foundation
import RealmSwift

class WeatherDetail : Object {
    @objc dynamic var key: String  = ""
    @objc dynamic var weatherText : String = ""
    @objc dynamic var weatherIcon : Int = 1
    @objc dynamic var hasPrecipitation : Bool = false
    @objc dynamic var precipitationType : String = ""
    @objc dynamic var isDayTime : Bool = false
    @objc dynamic var tempMetricValue : Double = 0.0
    @objc dynamic var tempMetricUnit : String = ""
    @objc dynamic var tempImperialValue : Double = 0.0
    @objc dynamic var tempImperialUnit : String = ""
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
