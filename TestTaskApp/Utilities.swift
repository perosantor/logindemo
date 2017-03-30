//
//  Utilities.swift
//  TestTaskApp
//
//  Created by Petar Santor on 3/29/17.
//  Copyright © 2017 Petar Santor. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    class func getAccessToken() -> String? {
        return UserDefaults.standard.object(forKey: Constants.Key.AccessToken) as? String ?? nil
    }
    
    class func saveAccessToken(_ token:String) {
        UserDefaults.standard.set(token, forKey: Constants.Key.AccessToken)
    }
    
    class func removeAccessToken() {
        UserDefaults.standard.removeObject(forKey: Constants.Key.AccessToken)
    }
    
}
