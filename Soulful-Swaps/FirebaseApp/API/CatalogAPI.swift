//
//  CatalogAPI.swift
//  FirebaseApp
//
//  Created by Nurzhan Jandosov on 11/3/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

final class CatalogAPI {
  // 1
  static let shared = CatalogAPI()
  // 2
  private init() {

  }
    
    private let persistenceManager = PersistenceManager()
    private let httpClient = HTTPClient()
    private let isOnline = false
    
    func getItems() -> [Item] {
      return persistenceManager.getItems()
    }
      
    func addItem(_ item: Item, at index: Int) {
      persistenceManager.addItem(item, at: index)
      if isOnline {
        httpClient.postRequest("/api/addAlbum", body: item.description)
      }
    }
      
    func deleteAlbum(at index: Int) {
      persistenceManager.deleteItem(at: index)
      if isOnline {
        httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
      }
    }
}
