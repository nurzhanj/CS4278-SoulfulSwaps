//
//  InitialViewController.swift
//  CloudFunctions
//


import Foundation
import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser == nil{
            self.performSegue(withIdentifier: "toMenuScreen", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "validSession", sender: self)
        }
        
        //- Todo: Check if user is authenticated. If so, segue to the HomeViewController, otherwise, segue to the MenuViewController
        
        
     
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
}
