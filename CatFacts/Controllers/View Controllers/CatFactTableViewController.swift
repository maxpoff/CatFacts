//
//  CatFactTableViewController.swift
//  CatFacts
//
//  Created by Maxwell Poffenbarger on 1/23/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import UIKit

class CatFactTableViewController: UITableViewController {
    
    //MARK: - Properties
    var catFact: [CatFact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var currentPage = 0

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCatFacts()
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentPostAlert()
    }
    
    //MARK: - Private Methods
    private func fetchCatFacts() {
        currentPage += 1
        CatFactController.fetchCatFacts(page: currentPage) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let catFact):
                    self.catFact += catFact
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    private func presentPostAlert() {
        let alert = UIAlertController(title: "Add Cat Fact", message: "Create a new cat fact to be added to the server", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Cat Fact"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addCatFactAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let catFactTextField = alert.textFields?[0], let catFact = catFactTextField.text, !catFact.isEmpty else {return}
            
            CatFactController.postCatFact(details: catFact) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let catFact):
                        self.catFact.append(catFact)
                        print(catFact)
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                    }
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(addCatFactAction)
        
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catFact.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catFactCell", for: indexPath)
        
        if indexPath.row == catFact.count - 1 {
            fetchCatFacts()
        }
        
        let cat = catFact[indexPath.row]

        cell.textLabel?.text = cat.details

        return cell
    }
}//End of class
