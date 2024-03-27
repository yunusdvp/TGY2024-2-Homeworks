//
//  SearchBarVC.swift
//  Homeworks-6
//
//  Created by Yunus Emre ÖZŞAHİN on 27.03.2024.
//

import UIKit

class SearchBarVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var users = [User]()
    var filteredUsers = [User]()
    
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let urlString = "https://jsonplaceholder.typicode.com/users"
        
        guard let url = URL(string: urlString) else { return }
        
        guard let users = try? JSONDecoder().decode([User].self, from: Data(contentsOf: url)) else { return }
        
        self.users = users
        
    }
}

extension SearchBarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        if isFiltering {
            cell.textLabel?.text = filteredUsers[indexPath.row].name
        } else {
            cell.textLabel?.text = users[indexPath.row].name
        }
        
        return cell
    }

}

extension SearchBarVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        
        filteredUsers = users.filter({ user -> Bool in
            return user.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        if filteredUsers.isEmpty {
                    tableView.setEmptyMessage("İstediğiniz kullanıcı bulunamadı")
                } else {
                    tableView.restore()
                }
        tableView.reloadData()
        if searchBar.text == ""{
            isFiltering = false
            tableView.reloadData()
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        
        searchBar.text = ""
        
        tableView.reloadData()
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()

        self.backgroundView = label
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
