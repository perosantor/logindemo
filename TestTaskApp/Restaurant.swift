//
//  Restaurant.swift
//  TestTaskApp
//
//  Created by Petar Santor on 3/29/17.
//  Copyright © 2017 Petar Santor. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    let name: String?
    let intro: String?
    let opened: String?
    let welcomeMessage: String?
    
    init(name: String?, intro: String?, opened: String?, welcomeMessage: String?) {
        self.name = name
        self.intro = intro
        self.opened = opened
        self.welcomeMessage = welcomeMessage
    }
}
