//
//  ListedItemTableViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/25/20.
//

import UIKit

@available(iOS 13.0, *)
class ListedItemTableViewController: UITableViewController {
    
    let user = trueUser
    
    

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
        return user.items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListedItemTableViewCell
        
        
        let item = user.items[indexPath.row]
        let image = UIImage(named: item.picture)
        let points = "Valued at " + String(item.pointVal) + " points"
        print(points)
        cell.itemImage.image = image
        cell.itemName.text = item.name
        cell.itemPoints.text = points
        cell.itemSize.text = item.size
        cell.itemWear.text = item.wear
        
        cell.itemName.backgroundColor = .white
        cell.itemPoints.backgroundColor = .white
        cell.itemSize.backgroundColor = .white
        cell.itemWear.backgroundColor = .white
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController)!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.item = user.items[indexPath.row]
    }

}
