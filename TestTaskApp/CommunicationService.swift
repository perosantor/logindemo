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
                
                //responseString = Optional("{\"message\":\"Restaurant beacon not found\",\"status_code\":500}")
//                {
//                    "access_token" : "64cdfb62690f56cdc3c06266157e447580e8a4a4",
//                    "favorites" : {   "items": [],
//                                      "restaurants": []    }
//                }
//                responseString = Optional("{\"message\":\"We weren\'t able to find an account with the email address you entered. Please 
                //check your email address and try again.\",\"status_code\":500}")
                
            }
            task.resume()
        }
        
        
    }
}
