//
//  CommunicationService.swift
//  TestTaskApp
//
//  Created by Petar Santor on 3/27/17.
//  Copyright © 2017 Petar Santor. All rights reserved.
//

import Foundation

struct CommunicationService {
    static let sharedInstace = CommunicationService()
    
    let newsUrl = "http://www.dzsabac.org.rs/android/droid.php"
    
    func logInWith(email:String?, password:String?, completion: @escaping (_ response:String?) -> ()) {
        completion("accessToken")
    }
}
