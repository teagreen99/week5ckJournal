//
//  EntryListTableViewController.swift
//  Week5AfternoonProject
//
//  Created by Tim Green on 5/10/21.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    // MARK: - Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        EntryController.sharedInstance.fetchEntriesWith { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EntryController.sharedInstance.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.sharedInstance.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.formatToString()
        
        return cell
    }
    
    // MARK: - Helper Fuctions
    
    func setupViews() {
        
        refresh.attributedTitle = NSAttributedString(string: "Pull to see new Entries.")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    @objc func loadData() {
        EntryController.sharedInstance.fetchEntriesWith { result in
            
            switch result {
            
            case .success(let chicken):
                let entries = chicken 
                EntryController.sharedInstance.entries = entries
                self.updateViews()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    } // End of function
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditDetailVC" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as?
                    EntryDetailViewController else {return}
            
            let entry = EntryController.sharedInstance.entries[indexPath.row]
            destinationVC.entry = entry
        }
    }
} // End of class
