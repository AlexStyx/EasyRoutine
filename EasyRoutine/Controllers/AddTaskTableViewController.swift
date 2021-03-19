//
//  AddTaskTableViewController.swift
//  EasyRoutine
//
//  Created by Александр Бисеров on 16.01.2021.
//

import UIKit
import CoreData

class AddTaskTableViewController: UITableViewController {
    
    let taskManager = TaskManager()
    var task: Task!
    var isSelected: Bool = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextVIew: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if task != nil {
            updateUI()
        }
        updateSaveButtonState()
    }
    
    @IBAction func typeInsideTextField(_ sender: Any) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "save" else { return }
        if !isSelected {
            saveNewTask()
        } else {
            saveTaskChanges()
            isSelected = false
        }
    }
    
    private func updateUI() {
        taskTitleTextField.text = task.title
        taskDescriptionTextVIew.text = task.descriprion
        datePicker.date = task.date ?? Date()
    }
    
    private func updateSaveButtonState() {
        if taskTitleTextField.text == "" {
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
    }
    
    private func saveTaskChanges() {
        taskManager.saveTaskChanges(task: self.task, newTitle: taskTitleTextField.text ?? "", newDescription: taskDescriptionTextVIew.text ?? "", newDate: datePicker.date)
    }
    
    private func saveNewTask() {
        
        taskManager.saveTask(title: taskTitleTextField.text ?? "", description: taskDescriptionTextVIew.text ?? "", date: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
