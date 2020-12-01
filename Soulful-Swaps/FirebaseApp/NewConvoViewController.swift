//
//  NewConvoViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 12/1/20.
//

import UIKit
import JGProgressHUD

class NewConvoViewController: UIViewController {
    
    public var completion: (([String: String]) -> (Void))?
    
    private var results = [[String:String]]()
    
    private let spinner = JGProgressHUD(style: .dark)
    private let searchBar: UISearchBar =  {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Conversations"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var users = [[String: String]]()
    private var hasFetched = false
    
    private let noResults: UILabel = {
        let label = UILabel()
        label.text = "No users matching your search"
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResults)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        searchBar.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResults.frame = CGRect(x: Int(view.bounds.width)/4, y: (Int(view.bounds.height - 200))/2, width: Int(view.bounds.width)/2, height: 200)
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    


}

extension NewConvoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["username"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start convo
        let targetUserData = results[indexPath.row]
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
        
    }
    
}

extension NewConvoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        
        searchBar.resignFirstResponder()
        results.removeAll()
        spinner.show(in: view)
        
        self.searchUsers(query: text)
        
    }
    
    func searchUsers(query: String){
        
        if hasFetched{
            //filter
            filterUsers(with: query)
        }
        else{
            //fetch
            DatabaseManager.shared.getAllUsers(completion: {
                [weak self] result in
                switch result{
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        }
        
    }
    
    func filterUsers(with term: String){
        guard hasFetched else{
            return
        }
        
        self.spinner.dismiss()

        let results: [[String:String]] = self.users.filter({
                    guard let name = $0["username"]?.lowercased() else {
                        return false
                    }

                    return name.hasPrefix(term.lowercased())
                })

                self.results = results

                updateUI()
    }
    
    func updateUI(){
        if results.isEmpty{
            self.noResults.isHidden = false
            self.tableView.isHidden = true
        }
        else{
            self.noResults.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}
