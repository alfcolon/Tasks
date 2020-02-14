//
//  TasksTableViewController.swift
//  Tasks
//
//  Created by alfredo on 2/14/20.
//  Copyright © 2020 Alfredo. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {

    //MARK: - Properties
    
    //inefficient, the fetch request will be executed everytime we access tasks
    private var tasks: [Task] {
        //fetch tasks from managed object context
        let fetchRequest: NSFetchRequest<Task>  = Task.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest) }
        catch {
            print("Error fetching tasks: \(error)")
            return [] }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(task)
            do {
                try moc.save()
                tableView.reloadData() }
            catch {
                moc.reset()
                print("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetail" else { return }
        
        let detailVC = segue.destination as! TaskDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            detailVC.task = tasks[indexPath.row]
        }
    }

}
