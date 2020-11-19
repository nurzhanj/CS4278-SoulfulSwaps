//
//  ViewController.swift
//  MessagePractice
//
//  Created by CJ Rorex on 11/16/20.
//  Copyright © 2020 CJ Rorex. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    // Three functions that will be needed in order to do this UI, according to the YouTube video
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "John Smith"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Push the controller
        let vc = ChatViewController()
        // This will be the other user's name
        vc.title = "Chat"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Show the chat messages afterwards
}

