//
//  User.swift
//  FirebaseApp
//
//  Created by Isabel Amat on 11/2/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

class User {
    var user_id: Int
    var username: String?
    var email: String?
    var password: String?

    init(user_id:Int, username:String?, email:String?, password:String?)
    {
        self.user_id = user_id
        self.username = username
        self.password = password
        self.email = email
    }
    
}
