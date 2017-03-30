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
    let is_open: Bool
    let welcomeMessage: String?
    let thumbnailImageUrl: String?
    
    init(name: String?, intro: String?, is_open: Bool, welcomeMessage: String?, thumbnailImageUrl: String?) {
        self.name = name
        self.intro = intro
        self.is_open = is_open
        self.welcomeMessage = welcomeMessage
        self.thumbnailImageUrl = thumbnailImageUrl
    }
}
