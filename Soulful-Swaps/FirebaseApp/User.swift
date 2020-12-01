//
//  User.swift
//  FirebaseApp
//
//  Created by Isabel Amat on 11/2/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//
import Foundation
import UIKit

class User {
    var user_id: Int
    var username: String?
    var email: String?
    var password: String?
    var pfp: UIImage
    var bgImage: UIImage
    var items: [ListedItem]
    
    var safeEmail: String{
        var safeEmail = email?.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail?.replacingOccurrences(of: "@", with: "-")
        return safeEmail!
    }

    init(user_id:Int, username:String?, email:String?, password:String, pfp:String, bgImage:String, items: [ListedItem])
    {
        self.user_id = user_id
        self.username = username
        self.password = password
        self.email = email
        self.pfp = UIImage(named: "profile")!
        self.bgImage = UIImage(named: "userBgImageTest")!
        self.items = [ListedItem](repeating: ListedItem(), count: 9)
        print(self.email!)
        print(self.username!)
    }
    
    //default ctor for testing
    init()
    {
        self.user_id = 0
        self.username = "user"
        self.password = "pass"
        self.email = "test@test.com"
        self.pfp = UIImage(named: "userPfpTest")!
        self.bgImage = UIImage(named: "userBgImageTest")!
        items = [ListedItem](repeating: ListedItem(), count: 9)
    }
    
    
}
