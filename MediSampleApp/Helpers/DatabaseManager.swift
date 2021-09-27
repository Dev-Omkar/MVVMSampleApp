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
    
    func insertData(postModel:PostDataModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else { return  }
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(postModel.id.stringValue, forKeyPath: "id")
        user.setValue(postModel.title, forKey: "title")
        user.setValue(postModel.body, forKey: "body")
        user.setValue(postModel.userId.stringValue, forKey: "userId")
        if let exist = getPostRecord(id: postModel.id){
            user.setValue(exist.isFavourite.intValue.stringValue, forKey: "isFavourite")
        }else{
            user.setValue("0", forKey: "isFavourite")
        }
        
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
    
    func retrieveData() -> [PostDataModel] {
        var postModels : [PostDataModel] = [PostDataModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return postModels}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            var postModel = PostDataModel.init()
            for data in result as! [NSManagedObject] {
                postModel = PostDataModel.init()
                postModel.id = Int(data.value(forKey: "id") as? String ?? "0") ?? 0
                postModel.title = data.value(forKey: "title") as? String ?? ""
                postModel.body = data.value(forKey: "body") as? String ?? ""
                postModel.userId = Int(data.value(forKey: "userId") as? String  ?? "0") ?? 0
                postModel.isFavourite =  Int(data.value(forKey: "isFavourite") as? String  ?? "0")?.boolValue ?? false
                postModels.append(postModel)
                
            }
        } catch {
            print("Failed")
        }
        return postModels
    }
    
    
    func retrieveFavData() -> [PostDataModel] {
        var postModels : [PostDataModel] = [PostDataModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return postModels}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %@","1")
        do {
            let result = try managedContext.fetch(fetchRequest)
            var postModel = PostDataModel.init()
            for data in result as! [NSManagedObject] {
                postModel = PostDataModel.init()
                postModel.id = Int(data.value(forKey: "id") as? String ?? "0") ?? 0
                postModel.title = data.value(forKey: "title") as? String ?? ""
                postModel.body = data.value(forKey: "body") as? String ?? ""
                postModel.userId = Int(data.value(forKey: "userId") as? String  ?? "0") ?? 0
                postModel.isFavourite =  Int(data.value(forKey: "isFavourite") as? String  ?? "0")?.boolValue ?? false
                postModels.append(postModel)
                
            }
        } catch {
            print("Failed")
        }
        return postModels
    }
    
    func getPostRecord(id:Int) -> PostDataModel? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "id == %@","\(id)")
        
        do {
            let result = try context.fetch(fetchRequest)
            var postModel = PostDataModel.init()
            for data in result as! [NSManagedObject] {
                postModel = PostDataModel.init()
                postModel.id = Int(data.value(forKey: "id") as? String ?? "0") ?? 0
                postModel.title = data.value(forKey: "title") as? String ?? ""
                postModel.body = data.value(forKey: "body") as? String ?? ""
                postModel.userId = Int(data.value(forKey: "userId") as? String  ?? "0") ?? 0
                postModel.isFavourite =  Int(data.value(forKey: "isFavourite") as? String  ?? "0")?.boolValue ?? false
                return postModel
            }
        } catch {
            print("Failed")
        }
        return nil
    }
    func updateFavourite(isFav: Bool,id:Int) {
        let value = isFav.intValue.stringValue
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.predicate = NSPredicate(format: "id == %@","\(id)")
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned 
                // In my case, I only updated the first item in results
                results?[0].setValue(value, forKey: "isFavourite")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
}



