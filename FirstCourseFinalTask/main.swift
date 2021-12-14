//
//  main.swift
//  FirstCourseFinalTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

let checker = Checker(usersStorageClass: UsersStorage.self,
                      postsStorageClass: PostsStorage.self)
checker.run()
