//
//  ConversationsViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/30/20.


import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController{
    
    
    
    private let tableView: UITableView! = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let noConvos: UILabel = {
        let label = UILabel()
        label.text = "No Convos"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(backToExplore))
        view.addSubview(tableView)
        view.addSubview(noConvos)
        setupTableView()
        fetchConversations()
    }
    
    @objc private func backToExplore(){
        navigationController?.performSegue(withIdentifier: "messageToMarketplace", sender: self)
    }
    
    @objc private func didTapComposeButton(){
        let vc = NewConvoViewController()
        vc.completion = { [weak self] result in
            print("\(result)")
            self?.createNewConvo(result: result)

        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewConvo(result: [String: String]){
        guard let username = result["username"], let email = result["email"] else{
            return
        }
        let vc = ChatsViewController(with: email)
        vc.isNewConvo = true
        vc.title = username
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations(){
        tableView.isHidden = false
    }
    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello, World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatsViewController(with: "temp@gmail.com")
        vc.title = "Doug Dahl"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
