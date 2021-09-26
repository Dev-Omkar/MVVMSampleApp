//
//  DatabaseManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import UIKit
import CoreData
class DatabaseManager {
    public static let shared = DatabaseManager()
    let entityName = "Post"
    
    func insertData(postModel:PostModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else { return  }
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(postModel.id, forKeyPath: "id")
        user.setValue(postModel.title, forKey: "title")
        user.setValue(postModel.body, forKey: "body")
        user.setValue(postModel.userId, forKey: "userId")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func deleteAll(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch {
            print ("There was an error")
        }
    }
    
    func retrieveData() -> [PostModel] {
        var postModels : [PostModel] = [PostModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return postModels}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            var postModel = PostModel.init()
            for data in result as! [NSManagedObject] {
                postModel = PostModel.init()
                postModel.id = data.value(forKey: "id") as? Int ?? 0
                postModel.title = data.value(forKey: "title") as? String ?? ""
                postModel.body = data.value(forKey: "body") as? String ?? ""
                postModel.userId = data.value(forKey: "userId") as? Int ?? 0
                
                postModels.append(postModel)
                
            }
        } catch {
            print("Failed")
        }
        return postModels
    }
    
    
}



