//
//  UploadViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/3/20.
//

import UIKit
import DropDown

class UploadViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var wear: UITextField!
    @IBOutlet weak var size: UITextField!
    var imagePicker = UIImagePickerController()
    let dropDown = DropDown() //2
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   // @IBAction func saveImage(_ sender: UIButton) {
    // }
    
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
    
    
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {//3
      dropDown.dataSource = ["Never worn", "Lightly Worn", "Worn", "Roughly Worn"]//4
      dropDown.anchorView = sender //5
      dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
      dropDown.show() //7
      dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
        guard let _ = self else { return }
        sender.setTitle(item, for: .normal) //9
      }
    }
}


