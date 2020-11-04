//
//  ItemViewController.swift
//  FirebaseApp
//
//  Created by Nurzhan Jandosov on 11/3/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

final class ItemViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var undoBarButtonItem: UIBarButtonItem!
  @IBOutlet var trashBarButtonItem: UIBarButtonItem!
  
    override func viewDidLoad() {
      super.viewDidLoad()
     
      //1
      allItems = CatalogAPI.shared.getItems()

      //2
      tableView.dataSource = self
        
        showDataForItem(at: currentItemIndex)

    }

    private var currentItemIndex = 0
    private var currentItemData: [ItemData]?
    private var allItems = [Item]()
    

    private func showDataForItem(at index: Int) {
        
      if (index < allItems.count && index > -1) {
        let item = allItems[index]
        currentItemData = item.tableRepresentation
      } else {
        currentItemData = nil
      }
      tableView.reloadData()
    }
}

extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let itemData = currentItemData else {
        return 0
      }
      return itemData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      if let itemData = currentItemData {
        let row = indexPath.row
        cell.textLabel!.text = itemData[row].title
        cell.detailTextLabel!.text = itemData[row].value
      }
      return cell
    }
}
