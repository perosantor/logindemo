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
            } else {
                completion(nil, "Error")
            }
        }
    }
    
    
    func fetchRestaurantInformation(completion: @escaping (_ response:Restaurant?, _ errorMessage:String?) -> ()) {
        
        if let token:String = Utilities.getAccessToken() {
            let baseURL = "https://usemenu.com/playground/public/api/v2/restaurant/info?app_version=2.7.1"
            //hardcoded test data
            let jsonBody: [String: Any] = ["table_beacon": ["major": 5, "minor": 1],
                                           "access_token": token]
        
            self.networkRequest(requestUrl: baseURL, requestBody: jsonBody) { (json, errorMessage) in
                if errorMessage != nil {
                    completion(nil, errorMessage)
                } else {
                    if let restaurant = Restaurant.init(withJson: json) {
                        completion(restaurant, nil)
                    } else {
                        completion(nil, "Error")
                    }
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
                            let message = json["message"] as? String
                            completion(nil, message)
                        } else {
                            completion(json, nil)
                        }
                    }
                } catch {
                    completion(nil, "Error")
                }
            }
            task.resume()
        }
    }

    
    
}
