//
//  TaskManager.swift
//  EasyRoutine
//
//  Created by Александр Бисеров on 20.01.2021.
//

import Foundation
import CoreData
import UIKit

class TaskManager {
    let context: NSManagedObjectContext!
    var user: User!
    var tasks: NSMutableOrderedSet = []
    var uncompletedTasks: [Task] = []
    var completedTasks: [Task] = []
    var deletedTasks: [Task] = []
    var todayTasks: [Task] = []
    
    
    init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        let userName = "Alex"
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", userName)
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty{
                user = User(context: context)
                user.name = userName
                try context.save()
            } else {
                user = results.first
            }
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        tasks = user.tasks?.mutableCopy() as! NSMutableOrderedSet
        uncompletedTasks = self.tasks.filter{!($0 as! Task).isCompleted && !($0 as! Task).isRemoved} as! Array<Task>
        completedTasks = self.tasks.filter{($0 as! Task).isCompleted && !($0 as! Task).isRemoved} as! Array<Task>
        deletedTasks = self.tasks.filter{($0 as! Task).isRemoved} as! Array<Task>
    }
    
    func saveTask(title: String, description: String, date: Date) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: self.context) else {return}
        let task = Task(entity: entity, insertInto: context)
        task.title = title
        task.descriprion = description
        task.date = date
        task.isRemoved = false
        task.isCompleted = false
        tasks.add(task)
        user.tasks = self.tasks
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveTaskChanges(task: Task, newTitle: String, newDescription: String, newDate: Date) {
        let index = tasks.index(of: task)
        tasks.remove(task)
        task.title = newTitle
        task.descriprion = newDescription
        task.date = newDate
        tasks.insert(task, at: index)
        user.tasks = tasks
        do{
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func completeTask(at indexPath: IndexPath) {
        let task = uncompletedTasks.remove(at: indexPath.row)
        let index = tasks.index(of: task)
        tasks.remove(task)
        task.isCompleted = true
        tasks.insert(task, at: index)
        user.tasks = tasks
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func uncompleteTask(at indexPath: IndexPath) {
        let task  = completedTasks.remove(at: indexPath.row)
        let index = tasks.index(of: task)
        tasks.remove(task)
        task.isCompleted = false
        tasks.insert(task, at: index)
        user.tasks = tasks
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func removeTask(at indexPath: IndexPath, completed: Bool) {
        func remove(_ task: Task) {
            let index = tasks.index(of: task)
            tasks.remove(task)
            task.isRemoved = true
            tasks.insert(task, at: index)
            user.tasks = tasks
        }
        let task = completed ? completedTasks.remove(at: indexPath.row) : uncompletedTasks.remove(at: indexPath.row)
        remove(task)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func recoverTask(at indexPath: IndexPath) {
        let task = deletedTasks.remove(at: indexPath.row)
        let index = tasks.index(of: task)
        tasks.remove(task)
        task.isCompleted = false
        task.isRemoved = false
        tasks.insert(task, at: index)
       user.tasks = tasks
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let task = deletedTasks.remove(at: indexPath.row)
        context.delete(task)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func updateTasks() {
        tasks = user.tasks?.mutableCopy() as! NSMutableOrderedSet
        uncompletedTasks = sortTasks(at: tasks.filter{!($0 as! Task).isCompleted && !($0 as! Task).isRemoved} as! Array<Task>)
        completedTasks = tasks.filter{($0 as! Task).isCompleted && !($0 as! Task).isRemoved} as! Array<Task>
        deletedTasks = tasks.filter{($0 as! Task).isRemoved} as! Array<Task>
    }
    
    private func sortTasks(at array: [Task]) -> [Task] {
        return array.sorted{$0.date! < $1.date!}
    }
    
    func calculateProductivity() -> Int {
        let unremovedTasks = tasks.filter{!($0 as! Task).isRemoved} as! Array<Task>
        if !unremovedTasks.isEmpty && !completedTasks.isEmpty {
            let partOfTasksThatAreCompleted = Float(completedTasks.count) / Float(unremovedTasks.count)
            let productivity = Int(partOfTasksThatAreCompleted * 100)
            return productivity
        } else {
            return 0
        }
        
    }
}
