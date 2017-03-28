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
    
    func logInWith(email:String?, password:String?, completion: @escaping (_ response:String?) -> ()) {
        if Reachability.init()?.currentReachabilityStatus == .notReachable {
            completion("No internet for pass: \(password)" )
            
        } else {
            let baseURL = "https://usemenu.com/playground/public/api/v2/customer/login?app_version=2.7.1"
            let json: [String: Any] = ["email": "test@testmenu.com",
                                       "password": "test1234"]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            print("URL: \(jsonData)")
            
            var request = URLRequest(url: URL(string: baseURL)!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
        
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                //responseString = Optional("{\"message\":\"Restaurant beacon not found\",\"status_code\":500}")
            }
            task.resume()
        }
        
        
    }
}
