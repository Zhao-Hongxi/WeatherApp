//
//  City.swift
//  WeatherApp
//
//  Created by ivan on 2021/10/29.
//

import Foundation
import RealmSwift

class CityDetail : Object {
    @objc dynamic var key: String  = ""
    @objc dynamic var type : String = ""
    @objc dynamic var localizedName : String = ""
    @objc dynamic var countryID : String = ""
    @objc dynamic var countryLocalizedName : String = ""
    @objc dynamic var administrativeID : String = ""
    @objc dynamic var administrativeLocalizedName : String = ""
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
