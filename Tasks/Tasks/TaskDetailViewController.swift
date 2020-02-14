//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by alfredo on 2/14/20.
//  Copyright © 2020 Alfredo. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - Properties
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - IBActions
    
    @IBAction func saveTask(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard !name.isEmpty else { return }

        let notes = notesTextView.text

        if let task = task {
            //Editing an existing task
            task.name = name
            task.notes = notes
        }
        else {
            //Creating new tasks
            let _ = Task(name: name, notes: notes)
        }

        //Save change
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save() }
        catch {
            print("Error saving managed object context:\(error)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard isViewLoaded else { return }

        title = task?.name ?? "Create Task"
        nameTextField.text = task?.name
        notesTextView.text = task?.notes
    }
    
}
