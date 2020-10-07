//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by Jason Koceja on 10/6/20.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    // MARK: - Properties
    
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        entryTitleTextField.delegate = self
    }

    // MARK: - Actions
    
    @IBAction func saveEntryButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = entryTitleTextField.text, !title.isEmpty,
              let bodyText = entryBodyTextView.text, !bodyText.isEmpty else { return }
        
        EntryController.shared.createEntryWith(title: title, body: bodyText) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clearTextButtonTapped(_ sender: UIButton) {
        entryTitleTextField.text = ""
        entryBodyTextView.text = ""
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryTitleTextField.text = entry.title
        entryBodyTextView.text = entry.body
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTitleTextField.resignFirstResponder()
        return true
    }
}
