//
//  ToDoTableViewController.swift
//  EasyRoutine
//
//  Created by Александр Бисеров on 16.01.2021.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    let taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateToDoTableView()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        updateToDoTableView()
    }
    
    private func updateToDoTableView() {
        taskManager.updateTasks()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "selectTask" else { return }
        let indexPath = self.tableView.indexPathForSelectedRow!
        let navigationVC = segue.destination as! UINavigationController
        let addTaskVC = navigationVC.topViewController as! AddTaskTableViewController
        addTaskVC.task = taskManager.uncompletedTasks[indexPath.row]
        addTaskVC.isSelected = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskManager.uncompletedTasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        
        let task = taskManager.uncompletedTasks[indexPath.row]
        cell.taskLabel.text = task.title
        cell.descriptionLabel.text = task.descriprion        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            taskManager.removeTask(at: indexPath, completed: false)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeTask(at: indexPath.row, with: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    func completeTask(at rowIndex: Int, with indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: ""){
            (action, view, completion) in
            self.taskManager.completeTask(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.image = UIImage(systemName: "checkmark.circle")
        action.backgroundColor = .systemGreen
        return action
    }
}
