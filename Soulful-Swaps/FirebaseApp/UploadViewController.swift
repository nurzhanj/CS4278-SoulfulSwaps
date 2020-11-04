//
//  UploadViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/3/20.
//

import UIKit

class UploadViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var wear: UITextField!
    @IBOutlet weak var size: UITextField!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
    }
    
    @IBAction func onClickPickImage(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true;
        present(imagePicker, animated: true, completion: nil)
    }
    
}
    
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


