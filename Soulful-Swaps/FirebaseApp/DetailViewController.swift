//
//  DetailViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/26/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var points: UILabel!
    @IBOutlet var brand: UILabel!
    @IBOutlet var wear: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var deleteItem: UIButton!
    
    var item: ListedItem!
    
    
    override func viewDidLoad() {
        
        itemImage.image = UIImage(named: item.picture)
        itemDescription.text = item.name
        points.text = "Valued at " + String(item.pointVal) + " points"
        brand.text = item.brand
        wear.text = item.wear
        size.text = item.size
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
