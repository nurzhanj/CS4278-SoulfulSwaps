//
//  DatabaseManager.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/30/20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference();
    
    public func insertUser(with user: User){
        var safe = user.username?.replacingOccurrences(of: ".", with: "-")
        safe = user.username?.replacingOccurrences(of: "#", with: "-")
        safe = user.username?.replacingOccurrences(of: "$", with: "-")
        safe = user.username?.replacingOccurrences(of: "[", with: "-")
        safe = user.username?.replacingOccurrences(of: "]", with: "-")
        safe = user.username?.replacingOccurrences(of: "@", with: "-")
        safe = user.username?.replacingOccurrences(of: " ", with: "-")
        database.child(user.safeEmail).setValue([
            "username":safe
        ])
    }
    
    public func userExists(with email: String, completion: @escaping((Bool) -> Void)){
        
        database.child(email).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
}
