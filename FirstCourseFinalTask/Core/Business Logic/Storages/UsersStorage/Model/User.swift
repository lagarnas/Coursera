//
//  User.swift
//  FirstCourseFinalTask
//
//  Created by a.leonteva on 14.12.2021.
//  Copyright © 2021 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

struct User: UserProtocol {
    
    // MARK: - UserProtocol
    
    var storage: [UserInitialData]?
    var currentUserID: Identifier?
    var followers: [(followerId: Identifier, subscriptionId: Identifier)]?
    
    var id: Self.Identifier = ""
    var username: String    = ""
    var fullName: String    = ""
    var avatarURL: URL?
    
    var currentUserFollowsThisUser: Bool {
        var value = false
        guard let followers = followers else { return false }
        for (followerId, subscriptionId) in followers {
            if followerId == currentUserID && subscriptionId == id { value = true }
        }
        return value
    }
    
    var currentUserIsFollowedByThisUser: Bool {
        var value = false
        guard let followers = followers else { return false }
        for (followerId, subscriptionId) in followers {
            if followerId == id && subscriptionId == currentUserID { value = true }
        }
        return value
    }
    
    var followsCount: Int {
        var value = 0
        guard let followers = followers else { return 0 }
        for (followerId, _) in followers {
            if followerId == id { value += 1 }
        }
        return value
    }
    
    var followedByCount: Int {
        var value = 0
        guard let followers = followers else { return 0 }
        for (_, subscriptionId) in followers {
            if subscriptionId == id { value += 1 }
        }
        return value
    }
}
