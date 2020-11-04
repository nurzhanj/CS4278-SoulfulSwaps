//
//  Item.swift
//  FirebaseApp
//
//  Created by Nurzhan Jandosov on 11/3/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

struct Item {
    let name : String
    let brand : String
    let size : String
    let wear : String
    let coverUrl: String
    let pointVal : Int
}

extension Item : CustomStringConvertible {
  var description: String {
    return "name: \(name)" +
      " brand: \(brand)" +
      " size: \(size)" +
      " wear: \(wear)" +
    " point value: \(pointVal)"
  }
}

typealias ItemData = (title: String, value: String)

extension Item {
  var tableRepresentation: [ItemData] {
    return [
      ("Name", name),
      ("Brand", brand),
      ("Size", size),
      ("Wear", wear),
        ("Cost", String(pointVal))
    ]
  }
}
