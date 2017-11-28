//
//  CoreDataStack.swift
//  SPam
//
//  Created by wsjung on 2017. 11. 27..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let store = CoreDataStack()

    private init() {
        self.fetchNumbers()
        self.fetchContents()
    }
    
    var context : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var contents = [Content]()
    var numbers = [Number]()
    
    func storeNumber(title: String){
        if title.count == 0 {
            return
        }
        
        let number = NSEntityDescription.insertNewObject(forEntityName: "Number", into: context) as! Number
        number.number = title
        self.saveContext()
        self.fetchNumbers()
    }
    
    func storeContent(title: String){
        if title.count == 0 {
            return
        }
        let spam = NSEntityDescription.insertNewObject(forEntityName: "Content", into: context) as! Content
        spam.fileterString = title
        self.saveContext()
        self.fetchContents()
    }
    
    func fetchNumbers(){
        let fetchRequest = NSFetchRequest<Number>(entityName: "Number")
        self.numbers = try! context.fetch(fetchRequest)
    }
    
    func fetchContents(){
        let fetchRequest = NSFetchRequest<Content>(entityName: "Content")
        self.contents = try! context.fetch(fetchRequest)
    }
    
    func delete(spam: NSManagedObject){
        context.delete(spam)
        self.saveContext()
    }
    
    lazy var persistentContainer: CustomPersistantContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = CustomPersistantContainer(name: "SPam")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

class CustomPersistantContainer : NSPersistentContainer {
    
    static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.gguby.spam")!
    let storeDescription = NSPersistentStoreDescription(url: url)
    
    override class func defaultDirectoryURL() -> URL {
        return url
    }
}
