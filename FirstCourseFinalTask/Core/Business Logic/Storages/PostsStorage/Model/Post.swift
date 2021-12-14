//
//  Post.swift
//  FirstCourseFinalTask
//
//  Created by a.leonteva on 14.12.2021.
//  Copyright © 2021 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

struct Post: PostProtocol {
    
    typealias IdentifierUser = GenericIdentifier<UserProtocol>
    
    // MARK: - PostProtocol
    
    var id: Self.Identifier
    var author: GenericIdentifier<UserProtocol>
    var description: String
    var imageURL: URL
    var createdTime: Date
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    
    // MARK: - Init
    
    init(id: Self.Identifier,
         author: IdentifierUser,
         description: String,
         imageURL: URL,
         createdTime: Date,
         currentUserID: IdentifierUser,
         likes: [(IdentifierUser, Identifier)]) {
        self.id = id
        self.author = author
        self.description = description
        self.imageURL = imageURL
        self.createdTime = createdTime
        self.currentUserLikesThisPost = likes.contains(where: {$0.0 == currentUserID && $0.1 == id})
        self.likedByCount = likes.filter{ $0.1 == id }.count
    }
}
