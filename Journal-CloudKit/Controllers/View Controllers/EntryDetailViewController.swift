//
//  EntryDetailViewController.swift
//  Journal-CloudKit
//
//  Created by Brooke Kumpunen on 4/8/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //Landing pad!
    var selectedEntry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Methods
    func updateViews() {
        //Let's see, if we have an entry, then we need to show its title and bodyText.
        guard let entry = selectedEntry else {return}
        bodyTextView.text = entry.bodyText
        titleTextField.text = entry.title
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let bodyText = bodyTextView.text, !bodyText.isEmpty else {return}
        if let entry = selectedEntry {
            EntryController.shared.updateEntry(entry: entry, newTitle: title, newBody: bodyText) { (entry) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            EntryController.shared.createEntry(title: title, bodyText: bodyText) { (entry) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
