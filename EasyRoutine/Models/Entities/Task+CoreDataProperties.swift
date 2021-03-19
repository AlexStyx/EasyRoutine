//
//  Task+CoreDataProperties.swift
//  EasyRoutine
//
//  Created by Александр Бисеров on 17.01.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var descriprion: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isRemoved: Bool
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}

extension Task : Identifiable {

}
