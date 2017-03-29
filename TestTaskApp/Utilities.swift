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
        return UserDefaults.standard.object(forKey: Constants.Keys.AccessToken) as? String ?? nil
    }
    
    class func removeAccessToken() {
        UserDefaults.standard.removeObject(forKey: Constants.Keys.AccessToken)
    }
    
}
