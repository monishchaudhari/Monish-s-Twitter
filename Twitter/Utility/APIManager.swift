//
//  APIManager.swift
//  Twitter
//
//  Created by Monish Chaudhari on 23/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    let token = "AAAAAAAAAAAAAAAAAAAAALwyMAEAAAAA2l1wBxYZGsoU9lhHTtea%2FxhqsmI%3DsnLgobPloYJm21aMQILyzH8qY6pZPfZIhClLa2S639fEaw8vY2"
    var session: URLSession = {
        let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        urlSessionConfiguration.timeoutIntervalForRequest = 30.0
        urlSessionConfiguration.timeoutIntervalForResource = 30.0
        urlSessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlSessionConfiguration.urlCache = nil
        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    
    let baseURL = "https://api.twitter.com/2/users/"
    
    ///use this API to get info of the user by appending the twitter username Ex. 'users/by/username/<username>'
    let getUserInfo = "by/username/"
    
    ///use this API to get follers of the user by userID as adding prefix to the variable Ex. <userID>/followers
    let getFollowers = "/followers"
    
    ///use this API to get followings of the user by userID as adding prefix to the variable Ex. <userID>/followers
    let getFollowings = "/following"
    
    
    func makeAPICall(endPoint:String, method:RequestMethod, requestBody:Data?, HTTPHeaders: [String:String] = ["Content-Type":"application/json"], setBaseURL:String? = nil, completion: @escaping (Data? ,Error?, URLResponse?) ->()) -> URLSessionDataTask?{
        
        let URLString = ((setBaseURL ?? baseURL)+endPoint).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        ///Request Type
        var request = URLRequest(url: URL.init(string: URLString!)!)
        request.httpMethod = method.rawValue
        
        ///Request Headers
        for(key, value) in HTTPHeaders { request.setValue(value, forHTTPHeaderField: key) }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        

        if requestBody != nil {
            request.httpBody = requestBody!
        }
        
        ///Sending request to the server.
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                if let error = error as NSError? {
                    print(error)
                }
                completion(nil, error, response) }
            if (data != nil){
                #if DEBUG
                    self.LogAPI(request, responseData: data!, response: response)
                #endif
                completion(data, nil, response)
            }
        })
        task.resume()
        return task
    }
    
    private func LogAPI(_ request:URLRequest, responseData:Data?, response:URLResponse?){
        var logString: String = ""
        logString = logString + "\n\n\n\n\n----------API Call Start----------"
        logString = logString + "\nURL:\n\((request.url)!)"
        if let statusCode = (response as? HTTPURLResponse)?.statusCode{
            logString = logString + "\nStatus Code:\n\(statusCode)"
        }
        if let httpBody = request.httpBody
        {
            logString = logString + "\nRequest JSON:\n\(String(data: httpBody, encoding: String.Encoding.utf8)!)"
        }

        logString = logString + "\nRequest Headers:\n\(String(describing: request.allHTTPHeaderFields))"
        if let data = responseData{
            logString = logString + "\nResponse JSON:\n\(String(data: data, encoding: String.Encoding.utf8)!)"
        }
        logString = logString + "\n----------API Call End----------\n\n\n\n\n"
        #if DEBUG
        print(logString)
        #endif
    }
}


enum RequestMethod: String {
    case GET
    case POST
}
