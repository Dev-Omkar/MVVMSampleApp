//
//  RepositoryManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class RepositoryManager {
    static var sharedInstance = ApiService.init()
    func getPosts(completion:@escaping (Result<[PostModel], URLError>) -> Void) {
        let rechability = RechabilityManager.shared
        if rechability.isReachable{
            ApiService.sharedInstance.getPosts() { response in
                completion(response)
            }
        }else{
            return completion(.success(DatabaseManager.shared.retrieveData()))
        }
    }
}
