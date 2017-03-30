//
//  CommunicationService.swift
//  TestTaskApp
//
//  Created by Petar Santor on 3/27/17.
//  Copyright © 2017 Petar Santor. All rights reserved.
//

import Foundation
import ReachabilitySwift

struct CommunicationService {
    static let sharedInstace = CommunicationService()
    
    func logInWith(email:String, password:String, completion: @escaping (_ token:String?, _ errorMessage:String?) -> ()) {
        
        let baseURL = "https://usemenu.com/playground/public/api/v2/customer/login?app_version=2.7.1"
        let jsonBody: [String: Any] = ["email": email,
                                       "password": password]
        
        self.networkRequest(requestUrl: baseURL, requestBody: jsonBody) { (json, errorMessage) in
            if json != nil {
                let token = json?["access_token"] as? String
                completion(token, nil)
            } else if json == nil && errorMessage != nil {
                completion(nil, errorMessage)
            }
        }
    }
    
    func fetchRestaurantInformation(completion: @escaping (_ response:Restaurant?, _ errorMessage:String?) -> ()) {
        
        if let token:String = Utilities.getAccessToken() {
            print(token)
            let baseURL = "https://usemenu.com/playground/public/api/v2/restaurant/info?app_version=2.7.1"
            let jsonBody: [String: Any] = ["table_beacon": ["major": 5, "minor": 1],
                                           "access_token": token]
        
            
            self.networkRequest(requestUrl: baseURL, requestBody: jsonBody) { (json, errorMessage) in
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
                        
                        let restaurantInfo = Restaurant.init(name: name, intro: intro, is_open: is_open, welcomeMessage: welcomeMessage, thumbnailImageUrl: thumbnailImageUrl)
                        completion(restaurantInfo, nil)
                        
                    } else {
                         completion(nil, "No data for this restaurant found")
                    }
                } else if json == nil && errorMessage != nil {
                    completion(nil, errorMessage)
                }
            }

        } else {
            completion(nil, "Error. Please Log in again.")
        }
    }
    
    
    func networkRequest(requestUrl:String, requestBody:[String:Any], completion: @escaping (_ response:[String: Any]?, _ errorMessage:String?) -> ()) {
        if Reachability.init()?.currentReachabilityStatus == .notReachable {
            completion(nil, "No Internet access")
        } else {
            let jsonBodyData = try? JSONSerialization.data(withJSONObject: requestBody)
            
            var request = URLRequest(url: URL(string: requestUrl)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBodyData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil, "Error, please try again")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                            // check for http errors
//                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                            print("response = \(response)")
//                            
                            let message = json["message"] as? String
                            completion(nil, message)
                        } else {
                            completion(json, nil)
                        }
                        
//                        let responseString = String(data: data, encoding: .utf8)
//                        print("responseString = \(responseString)")
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion(nil, "Error")
                }
            }
            task.resume()
        }
    }

    
    
}
