//
//  UploadController.swift
//  FirebaseApp
//

import Foundation
import UIKit

class UploadController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnSelectImage(_ sender: Any) {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
}
