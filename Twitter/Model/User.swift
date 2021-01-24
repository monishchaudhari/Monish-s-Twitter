//
//  User.swift
//  Twitter
//
//  Created by Monish Chaudhari on 23/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import Foundation

class LoggedInUser: NSObject, Codable {
    
    static let shared = LoggedInUser()
    
    var user:User?
    var followers:Follow?
    var followings:Follow?
    
    func resetUser() {
        user = nil
        followers = nil
        followings = nil
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.User.rawValue)
    }
}

class User: NSObject, Codable {
    
    var id: String?
    var name: String?
    var username: String?
}

class Follow: NSObject, Codable {
    var data:[User]?
    var meta:Meta?
}

class Meta: NSObject, Codable {
    var result_count:Int?
    var next_token:String?
}

public enum UserDefaultEnum: String {
    case User = "LoggedInUser"
}
