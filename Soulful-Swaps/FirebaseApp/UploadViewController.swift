//
//  UploadViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/3/20.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var wear: UITextField!
    @IBOutlet weak var size: UITextField!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upload Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    @IBAction func saveItem(_ sender: Any) {
    }
    
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        dismiss(animated: true)
        selectedImage = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}


