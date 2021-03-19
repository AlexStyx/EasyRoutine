//
//  AccountViewController.swift
//  EasyRoutine
//
//  Created by Александр Бисеров on 18.01.2021.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {

    let taskManager = TaskManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    
    private func updateUI() {
        let stat = getStat()
        statLabel.text = "\(stat)%"
    }
    
    private func getStat() -> Int {
        taskManager.updateTasks()
        return taskManager.calculateProductivity()
    }
}
