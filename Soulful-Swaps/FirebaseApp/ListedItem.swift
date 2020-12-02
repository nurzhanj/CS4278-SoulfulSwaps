//
//  ListedItem.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/16/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

struct ListedItem : Hashable, Decodable {
    let name : String
    let brand : String
    let size : String
    let wear : String
    let picture : String
    let pointVal : Int
    let owner: String
    
    init(name: String, brand: String, size: String, wear: String, picture: String, pointVal: Int, owner: String){
        self.name = name
        self.brand = brand
        self.size = size
        self.wear = wear
        self.picture = picture
        self.pointVal = pointVal
        self.owner = owner
    }
    
    init(){
        self.name = "Gucci Bucket"
        self.brand = "Gucci"
        self.size = "Large"
        self.wear = "Well Worn"
        self.picture = "gucciBucket"
        self.pointVal = 1000000
        self.owner = "doug.dahl"
    }
}
