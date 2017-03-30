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
    
    func logInWith(email:String, password:String, completion: @escaping (_ response:String?, _ succeeded:Bool) -> ()) {
        if Reachability.init()?.currentReachabilityStatus == .notReachable {
            completion("No Internet access", false)
        } else {
            let baseURL = "https://usemenu.com/playground/public/api/v2/customer/login?app_version=2.7.1"
            let jsonBody: [String: Any] = ["email": email,
                                           "password": password]
            let jsonBodyData = try? JSONSerialization.data(withJSONObject: jsonBody)
            
            var request = URLRequest(url: URL(string: baseURL)!)
            request.httpMethod = "POST"
            request.httpBody = jsonBodyData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    completion("Error, please try again", false)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                            // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(response)")
                            
                            let message = json["message"] as? String
                            completion(message, false)
                        } else {
                            let token = json["access_token"] as? String
                            completion(token, true)
                        }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion("Error", false)
                }
            }
            task.resume()
        }
    }
    
    func fetchRestaurantInformation(completion: @escaping (_ response:Restaurant?, _ errorMessage:String?) -> ()) {
        if Reachability.init()?.currentReachabilityStatus == .notReachable {
            completion(nil, "No Internet access")
        } else {
            if let token:String = Utilities.getAccessToken() {
                print(token)
                let baseURL = "https://usemenu.com/playground/public/api/v2/restaurant/info?app_version=2.7.1"
                let jsonBody: [String: Any] = ["table_beacon": ["major": 5, "minor": 1],
                                               "access_token": token]
                
                let jsonBodyData = try? JSONSerialization.data(withJSONObject: jsonBody)
                var request = URLRequest(url: URL(string: baseURL)!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                //request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = jsonBodyData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    // check for fundamental networking error
                    guard let data = data, error == nil else {
                        print("error=\(error)")
                        completion(nil, "Error")
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                                // check for http errors
                                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                                print("response = \(response)")
                                
                                let message = json["message"] as? String
                                completion(nil, message)
                            } else {
                            
                                var name:String?
                                var intro:String?
                                var is_open:Bool = false
                                var welcomeMessage:String?
                                var thumbnailImageUrl:String?
                                
                                if let restaurant = json["restaurant"] as? [String: Any] {
                                    name = restaurant["name"] as? String
                                    intro = restaurant["intro"] as? String
                                    is_open = restaurant["is_open"] as! Bool
                                    welcomeMessage = restaurant["welcome_message"] as? String
                                    if let images = restaurant["images"] as? [String: Any] {
                                        thumbnailImageUrl = images["thumbnail_medium"] as? String
                                    }
                                }
                          
                                completion(Restaurant.init(name: name, intro: intro, is_open: is_open, welcomeMessage: welcomeMessage, thumbnailImageUrl: thumbnailImageUrl), nil)
                            }
                            
                            let responseString = String(data: data, encoding: .utf8)
                            print("responseString = \(responseString)")
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                        completion(nil, "Error")
                    }
                }
                task.resume()
            } else {
                completion(nil, "Error, please try and log in again")
            }
        }
    }
}
