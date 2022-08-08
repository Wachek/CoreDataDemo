//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Вячеслав Турчак on 08.08.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
     func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasks(with context: NSManagedObjectContext) -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var tasks: [Task] = []
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
        }
        return tasks
    }
    
    func saveTask(_ taskName: String, with context: NSManagedObjectContext) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) {
        context.delete(task)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
//    func deleteTask(_ taskName: String, with context: NSManagedObjectContext) {
//        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
//        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
//        task.title = taskName
//
//        if context.hasChanges {
//            context.delete(task)
//        }
//    }
    
    private init() {}
}
