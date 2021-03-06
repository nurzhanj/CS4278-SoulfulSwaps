//
//  DetailViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/26/20.
//

import UIKit

var trueUser = User()

class DetailViewController: UIViewController {
    
    var user = trueUser

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var points: UILabel!
    @IBOutlet var brand: UILabel!
    @IBOutlet var wear: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var deleteItem: UIButton!
    
    var item: ListedItem!
    
    @IBOutlet var owner: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.image = UIImage(named: item.picture)
        itemDescription.text = item.name
        points.text = "Valued at " + String(item.pointVal) + " points"
        brand.text = item.brand
        wear.text = item.wear
        size.text = item.size
        owner?.text = "Message \(item.owner) to make an offer"
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        
        print("delete is working")
        
        trueUser.items.remove(at: 0)
        
        self.performSegue(withIdentifier: "deleteItem", sender: self)
 
        
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
