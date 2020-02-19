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
    
    //will interact with task entity
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        //define how search results will be sorted
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true),
                                        NSSortDescriptor(key: "name", ascending: true)] //second level of sorting
        let moc = CoreDataStack.shared.mainContext
        //fetch results controler
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "priority", cacheName: nil)
        frc.delegate = self //allows us to talk to frc controller to get and respond to changes
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(task)
            do {
                try moc.save() }
            catch {
                moc.reset()
                print("Error saving managed object context: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        
        return sectionInfo.name.capitalized
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetail" else { return }
        
        let detailVC = segue.destination as! TaskDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            detailVC.task = fetchedResultsController.object(at: indexPath)
        }
    }

}

extension TasksTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            //change entire section
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
//            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
