//
//  EntryListTableViewController.swift
//  Journal-CloudKit
//
//  Created by Brooke Kumpunen on 4/8/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    //Gotta call the reloadData and fetchfunctions in the view did load.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.shared.fetchAllEntries { (entry) in
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
        return EntryController.shared.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text =  entry.timestamp.asStringWith(timeStyle: .none, dateStyle: .medium)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = EntryController.shared.entries[indexPath.row]
            EntryController.shared.deleteEntry(entry: entry) { (entry) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntryDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let destinationVC = segue.destination as! EntryDetailViewController
            let selectedEntry = EntryController.shared.entries[indexPath.row]
            destinationVC.selectedEntry = selectedEntry
        }
    }
}

extension Date {
    func asStringWith(timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = timeStyle
        formatter.dateStyle = dateStyle
        return formatter.string(from: self)
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
