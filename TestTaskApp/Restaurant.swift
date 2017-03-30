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
    
    convenience init?(withJson json: [String:Any]?) {
        if json != nil {
            if let restaurant = json?["restaurant"] as? [String: Any] {
                let name = restaurant["name"] as? String
                let intro = restaurant["intro"] as? String
                let is_open = restaurant["is_open"] as! Bool
                let welcomeMessage = restaurant["welcome_message"] as? String
                var thumbnailImageUrl: String?
                if let images = restaurant["images"] as? [String: Any] {
                    thumbnailImageUrl = images["thumbnail_medium"] as? String
                }
    
                self.init(name: name,
                          intro: intro,
                          is_open: is_open,
                          welcomeMessage: welcomeMessage,
                          thumbnailImageUrl: thumbnailImageUrl)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
