//
//  PostsStorage.swift
//  FirstCourseFinalTask
//
//  Created by a.leonteva on 14.12.2021.
//  Copyright © 2021 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

final class PostsStorage: PostsStorageProtocol {
    
    typealias Identifier = GenericIdentifier<PostProtocol>
    typealias IdentifierUser = GenericIdentifier<UserProtocol>
    
    var posts: [PostInitialData]
    var currentUserID: IdentifierUser
    var likes: [(IdentifierUser, Identifier)]
    
    // MARK: - Init
    
    required init(posts: [PostInitialData],
                  likes: [(IdentifierUser, Identifier)],
                  currentUserID: IdentifierUser) {
        
        self.posts = posts
        self.currentUserID = currentUserID
        self.likes = likes
    }
    
    // MARK: - PostsStorageProtocol
    
    var count: Int { return posts.count }
    
    func post(with postID: Identifier) -> PostProtocol? {
        guard let postData = posts.filter({ $0.id == postID }).first else { return nil }
        
        let post = getPost(from: postData)
        
        return post
    }
    
    func findPosts(by authorID: IdentifierUser) -> [PostProtocol] {
        return posts.filter { $0.author == authorID }.map { getPost(from: $0) }
    }
    
    func findPosts(by searchString: String) -> [PostProtocol] {
        return posts.filter { $0.description == searchString }.map { getPost(from: $0) }
    }
    
    func likePost(with postID: Identifier) -> Bool {
        guard posts.contains(where: { $0.id == postID }) else { return false }
        
        guard likes.contains(where: { $0.0 == currentUserID && $0.1 == postID }) else {
            likes.append((currentUserID, postID))
            return true
        }
        return true
    }
    
    func unlikePost(with postID: Identifier) -> Bool {
        
        guard posts.contains(where: { $0.id == postID }) else { return false }
        
        guard likes.contains(where: { $0.0 == currentUserID && $0.1 == postID }) else { return true }
        likes.removeAll(where: { $0.0 == currentUserID && $0.1 == postID })
        
        return true
    }
    
    func usersLikedPost(with postID: Identifier) -> [IdentifierUser]? {
        guard posts.contains(where: { $0.id == postID }) else { return nil }
        
        var likers = [IdentifierUser]()
        let filteredLikes = likes.filter{ $0.1 == postID }
        let likesUsersIds = filteredLikes.map { $0.0 }
        
        if  !filteredLikes.isEmpty {
            likesUsersIds.forEach {
                likers.append($0)
            }
        }
        return likers
    }
    
    // MARK: - Private func
    
    private func getPost(from data: PostInitialData) -> Post {
        return Post(id: data.id,
                    author: data.author,
                    description: data.description,
                    imageURL: data.imageURL,
                    createdTime: data.createdTime,
                    currentUserID: currentUserID,
                    likes: likes)
    }
}
