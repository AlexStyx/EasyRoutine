//
//  DoneTasksTableViewController.swift
//  EasyRoutine
//
//  Created by Александр Бисеров on 18.01.2021.
//

import UIKit
import CoreData

class DoneTasksTableViewController: UITableViewController {
    
    let taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateDoneTasksTableView()
    }
    
    func updateDoneTasksTableView() {
        taskManager.updateTasks()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskManager.completedTasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        let task = taskManager.completedTasks[indexPath.row]
        cell.taskLabel.text = task.title
        cell.descriptionLabel.text = task.descriprion
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskManager.removeTask(at: indexPath, completed: true)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let undo = undoTask(at: indexPath.row, with: indexPath)
        return UISwipeActionsConfiguration(actions: [undo])
    }
    
    private func undoTask(at rowIndex: Int, with indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: ""){
            (action, view, completion) in
            self.taskManager.uncompleteTask(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.image = UIImage(systemName: "checkmark.circle")
        action.backgroundColor = .systemGray
        return action
        
    }
}


