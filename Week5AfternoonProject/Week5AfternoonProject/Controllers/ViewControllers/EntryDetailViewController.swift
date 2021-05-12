//
//  EntryDetailViewController.swift
//  Week5AfternoonProject
//
//  Created by Tim Green on 5/11/21.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextField: UITextView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              let body = bodyTextField.text, !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {return}
        
        EntryController.sharedInstance.createEntryWith(title: title, body: body) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    } // End of saveButtonTapped function

    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        titleTextField.text = ""
        bodyTextField.text = "Enter journal entry here..."
    }
    
    
    
    
    
    
    // MARK: - Helper Functions
    func updateViews() {
        
        if let entry = entry {
            titleTextField.text = entry.title
            bodyTextField.text = entry.body
        }
    } // End of function
} // End of class
    
// MARK: - Extensions
extension EntryDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
} // End of extension
