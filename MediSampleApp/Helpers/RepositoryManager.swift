//
//  RepositoryManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class RepositoryManager {
    func getPosts(completion:(Result<[PostModel], URLError>) -> Void) {
        let rechability = RechabilityManager.shared
        if rechability.isReachable{
            ApiManager.sharedInstance.getPosts()
        }else{
            return completion(.success(DatabaseManager.shared.retrieveData()))
        }
    }
}
