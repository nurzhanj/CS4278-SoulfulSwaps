//
//  ListedItemTableViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/25/20.
//

import UIKit

class ListedItemTableViewController: UITableViewController {
    
    let item = ListedItem()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListedItemTableViewCell
        
        
        let image = UIImage(named: item.picture)
        cell.itemImage.image = image
        cell.itemName.text = item.name
        cell.itemPoints.text = String(item.pointVal)
        cell.itemSize.text = item.size
        cell.itemWear.text = item.wear
        // Configure the cell...

        return cell
    }

}
