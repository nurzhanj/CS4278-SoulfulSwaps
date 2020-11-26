//
//  PfpViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/25/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

class PfpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.itemView.image = UIImage(named: user.items[indexPath.row].picture)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profilePicture: UIImageView!

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var user = User()
    
    override func viewDidLoad() {
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        coverImage.image = user.bgImage
        profilePicture.image = user.pfp
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
