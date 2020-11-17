//
//  AreaContainer.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/16/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

struct AreaContainer : Hashable, Decodable{
    
    let ID : Int
    let name : String
    let items : [ListedItem]
    
}
