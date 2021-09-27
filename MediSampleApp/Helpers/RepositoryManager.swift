//
//  RepositoryManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class RepositoryManager {
    static var sharedInstance = RepositoryManager.init()
    typealias complete = (Result<[PostDataModel], URLError>) -> Void
    func getPosts(completion:@escaping complete) {
        let rechability = RechabilityManager.shared
        if rechability.isReachable{
            ApiService.sharedInstance.getPosts() { response in
                switch(response){
                case .success(let models):
                    var empData = [PostDataModel]()
                    empData.removeAll()
                    for mode in models{
                        var dataModel = PostDataModel.init()
                        dataModel.body = mode.body
                        dataModel.title = mode.title
                        dataModel.id = mode.id
                        dataModel.userId = mode.userId
                        dataModel.isFavourite = false
                        empData.append(dataModel)
                    }
                    self.doDatabaseOperations(empData: empData)
                    completion(.success(empData))
                case .failure(let error):  
                    completion(.failure(error))
                }
            }
        }else{
            return completion(.success(DatabaseManager.shared.retrieveData()))
        }
    }
    
    func doDatabaseOperations(empData:[PostDataModel]){
        DispatchQueue.main.async {
            DatabaseManager.shared.deleteAll()
            for post in empData{
                DatabaseManager.shared.insertData(postModel: post)
            }
            let newPost = DatabaseManager.shared.retrieveData()
            print("inserted posts: \(newPost.count )")
        }
    }
}
