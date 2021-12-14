//
//  UserStorage.swift
//  FirstCourseFinalTask
//
//  Created by a.leonteva on 14.12.2021.
//  Copyright © 2021 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

final class UsersStorage: UsersStorageProtocol {
    
    typealias Identifier = GenericIdentifier<UserProtocol>
    
    private var user: User
    
    // MARK: - Init
    
    required init?(users: [UserInitialData], followers: [(Identifier, Identifier)], currentUserID: Identifier) {
        guard users.isEmpty != true else { return nil }
        guard users.contains(where: {$0.id == currentUserID}) else{ return nil }
        
        user = User(storage: users, currentUserID: currentUserID, followers: followers)
    }
    
    // MARK: - UsersStorageProtocol

    var count: Int { return user.storage?.count ?? 0 }

    func currentUser() -> UserProtocol {
        let userData = user.storage?.filter{ $0.id == user.currentUserID }.first
        return getUser(from: userData)
    }
    
    func user(with userID: Identifier) -> UserProtocol? {
        let userData = user.storage?.filter { $0.id == userID }.first
        guard userData?.id != nil else { return nil }
        return getUser(from: userData)
    }
    
    func findUsers(by searchString: String) -> [UserProtocol] {
        return user.storage?.filter { $0.username == searchString }.map { getUser(from: $0)} ?? []
    }
    
    func follow(_ userIDToFollow: Identifier) -> Bool {
        guard let storage = user.storage, let currentID = user.currentUserID else { return false }
        guard (storage.contains(where: {$0.id == userIDToFollow})) else { return false }
        guard (user.followers?.contains(where: {$0.0 == user.currentUserID && $0.1 == userIDToFollow})) == false else { return true }
        
        user.followers?.append((currentID, userIDToFollow))
        
        return true
    }
    
    func unfollow(_ userIDToUnfollow: Identifier) -> Bool {
        guard let storage = user.storage, let followers = user.followers else { return false }
        guard (storage.contains(where: {$0.id == userIDToUnfollow})) else { return false }
        guard followers.contains(where: {$0.0 == user.currentUserID && $0.1 == userIDToUnfollow}) else { return true }
        
        let follower = (user.currentUserID, userIDToUnfollow)
        for (index,value) in followers.enumerated() {
            if follower == value { user.followers?.remove(at: index) }
        }
        
        return true
    }
    
    func usersFollowingUser(with userID: Identifier) -> [UserProtocol]? {
        guard let storage = user.storage else { return nil }
        guard let followers = user.followers else { return [] }
        guard storage.contains(where: {$0.id == userID}) else { return nil }
        
        var followingUsers: [User] = []
        let filteredFollowingUsers = followers.filter { $0.1 == userID }
        let followingUsersIDs = filteredFollowingUsers.map { $0.0 }
        let usersIDs = storage.map { $0.id }
        
        if !filteredFollowingUsers.isEmpty {
            followingUsersIDs.forEach { id in
                if usersIDs.contains(id) {
                    guard let followingUserData = storage.filter({ $0.id == id }).first else { return }
                    let followingUser = getUser(from: followingUserData)
                    followingUsers.append(followingUser)
                }
            }
        }
        return followingUsers
    }
    
    func usersFollowedByUser(with userID: Identifier) -> [UserProtocol]? {
        
        guard let storage = user.storage else { return nil }
        guard let followers = user.followers else { return [] }
        guard storage.contains(where: {$0.id == userID}) else { return nil }
        
        var usersFollowedBy: [User] = []
        let filteredUsersFollowedBy = followers.filter { $0.0 == userID }
        let usersFollowedByIDs = filteredUsersFollowedBy.map { $0.1 }
        let usersIDs = storage.map { $0.id }
        
        if !filteredUsersFollowedBy.isEmpty {
            usersFollowedByIDs.forEach { id in
                if usersIDs.contains(id) {
                    guard let usersFollowedByData = storage.filter({ $0.id == id }).first else { return }
                    let follower = getUser(from: usersFollowedByData)
                    usersFollowedBy.append(follower)
                }
            }
        }
        return usersFollowedBy
    }
    
    // MARK: - Private func
    
    private func getUser(from data: UserInitialData?) -> User {
        user.id = data?.id ?? ""
        user.fullName = data?.fullName ?? ""
        user.username = data?.username ?? ""
        return user
    }
}
