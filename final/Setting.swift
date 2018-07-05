//
//  File.swift
//  final
//
//  Created by CheungTin Long on 24/6/2018.
//  Copyright © 2018年 CheungTin Long. All rights reserved.
//

import UIKit

class Setting : NSObject{
    static var SharedInstance:Setting? = nil
    
    var cities = String()
    private var _weatherTableCities : [String]? = UserDefaults.standard.array(forKey: "weatherTableCities") as? [String]
    var weatherTableCities : [String]? {
        set(newValue) {
            self._weatherTableCities = newValue
            UserDefaults.standard.set(self._weatherTableCities, forKey: "weatherTableCities")
        }
        get {
            if self._weatherTableCities == nil {
                self._weatherTableCities = ["基隆市"]
            }
            
            return self._weatherTableCities
        }
    }
    
    static func sharedInstance() -> Setting{
        
        if(Setting.SharedInstance == nil) {
            Setting.SharedInstance = Setting()
        }
        
        return Setting.SharedInstance!
    }
}
