//
//  PersistenceManager.swift
//  FirebaseApp
//
//  Created by Nurzhan Jandosov on 11/3/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

final class PersistenceManager {
    private var items = [Item]()

    init() {
      //Dummy list of items
      let item1 = Item(name: "Red Nike Golf Shirt",
                         brand: "Nike",
                         size: "L",
                         wear: "Medium",
                         coverUrl: "https://di2ponv0v5otw.cloudfront.net/posts/2020/06/05/5edab10fff8304d54dcd541e/m_5edab1402ca9ab9164546592.jpg",
                         pointVal: 25)
        
      let item2 = Item(name: "Blue Retro Sweater",
                       brand: "Nike",
                       size: "M",
                       wear: "Light",
                       coverUrl: "https://i.pinimg.com/originals/7a/15/8c/7a158cd01927f93fa4063d0d375f5f59.jpg",
                       pointVal: 75)
        
      items = [item1, item2]
    }
    
    func getItems() -> [Item] {
      return items
    }
      
    func addItem(_ item: Item, at index: Int) {
      if (items.count >= index) {
        items.insert(item, at: index)
      } else {
        items.append(item)
      }
    }
      
    func deleteItem(at index: Int) {
      items.remove(at: index)
    }
}
