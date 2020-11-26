//
//  SignUpViewController.swift
//  CloudFunctions
//
//  Created by Robert Canton on 2017-09-13.
//  Copyright © 2017 Robert Canton. All rights reserved.
//
import Foundation
import UIKit
import SQLite3

class SignUpViewController:UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(secondaryColor, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.white
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
        textFieldUsername.delegate = self
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
        textFieldUsername.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textFieldEmail.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textFieldPassword.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textFieldUsername.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    
    /**
     Enables the continue button if the **username**, **email**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = textFieldUsername.text
        let email = textFieldEmail.text
        let password = textFieldPassword.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
         // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        case textFieldUsername:
            textFieldUsername.resignFirstResponder()
            textFieldEmail.becomeFirstResponder()
            break
        case textFieldEmail:
            textFieldEmail.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
            break
        case textFieldPassword:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc func handleSignUp() {
        guard let username = textFieldUsername.text else { return }
        guard let email = textFieldEmail.text else { return }
        guard let pass = textFieldPassword.text else { return }
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
    }
}
