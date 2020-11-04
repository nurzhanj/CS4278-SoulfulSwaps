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

class SignUpViewController:UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    var userList = [User]()
    var db: OpaquePointer?

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func buttonSave(_ sender: UIButton) {
        //get values from text fields
        let username = textFieldUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = textFieldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = textFieldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
         //validate that values are not empty
        if(username?.isEmpty)!{
            textFieldUsername.layer.borderColor = UIColor.red.cgColor
            return
        }
         
        if(email?.isEmpty)!{
            textFieldEmail.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if(password?.isEmpty)!{
            textFieldPassword.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        //creating a statement
        var stmt: OpaquePointer?
         
        //insert query
        let queryString = "INSERT INTO User (username, email, password) VALUES (?,?,?)"
         
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
    
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, email, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, password, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
    
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
         
        //emptying the textfields
        textFieldUsername.text=""
        textFieldEmail.text=""
        textFieldPassword.text=""
         
//      readValues()
        
        //displaying a success message
        print("User saved successfully")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view which is
        //total number of users in the list
        return userList.count
    }
    
    //this method is binding the user username with the tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let user: User
        user = userList[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }
    
//    func readValues(){
//
//        //first empty the list of users
//        userList.removeAll()
//
//        //this is our select query
//        let queryString = "SELECT u FROM User WHERE "
//
//        //statement pointer
//        var stmt:OpaquePointer?
//
//        //preparing the query
//        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing insert: \(errmsg)")
//            return
//        }
//
//        //traversing through all the records
//        while(sqlite3_step(stmt) == SQLITE_ROW){
//            let user_id = sqlite3_column_int(stmt, 0)
//            let username = String(cString: sqlite3_column_text(stmt, 1))
//            let email = String(cString: sqlite3_column_text(stmt, 2))
//            let password = String(cString: sqlite3_column_text(stmt, 3))
//
//        //adding values to list
//        userList.append(User(user_id: Int(user_id), username: String?(describing: username), email: String?(email), password: String?(password)))
//            }
//
//        self.tableView.reloadData()
//
//    }
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("SoulfulSwapsDB.sqlite")
        
        // open the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // create user table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS User (user_id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)", nil, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
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
