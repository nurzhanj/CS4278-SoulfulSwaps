//
//  PfpViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/25/20.
//

import UIKit
import FirebaseAuth

class PfpViewController: UIViewController {
    
    
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var profilePicture: UIImageView!


    @IBOutlet var itemCollection: UICollectionView!
    var user = User()
    
    override func viewDidLoad() {

        coverImage.image = user.bgImage
        profilePicture.image = user.pfp
        
        self.title = UserDefaults.standard.value(forKey: "username") as! String
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLogOut(_ target: UIBarButtonItem){
        
        //action sheet needs additional helpers to configure correctly on ipad --
        //https://www.youtube.com/watch?v=W8NzdN0h50I , 14:00
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else{
                return
            }
            do {
                try! FirebaseAuth.Auth.auth().signOut()
                strongSelf.performSegue(withIdentifier: "logOut", sender: strongSelf)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }

}

extension PfpViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.itemImage.image = UIImage(named: user.items[indexPath.row].picture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(identifier: "PfpDetailViewController") as! DetailViewController
            
            vc.item =  user.items[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            fatalError()
        }
        
        
    }
    
}

extension PfpViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = itemCollection.bounds
        
        return CGSize(width: bounds.width/2 - 10, height: bounds.height/2-40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

