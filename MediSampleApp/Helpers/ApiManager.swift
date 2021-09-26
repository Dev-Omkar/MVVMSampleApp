//
//  ApiManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class ApiManager{
    static var sharedInstance = ApiManager.init()
    func getPosts(completion:@escaping (Result<[PostModel], URLError>)-> Void){
        let request = APIRequest(method: .get, path: "posts")
        APIClient().perform(request) { (result) in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: [PostModel].self) {
                    let posts = response.body
                    completion(.success(posts))
//                    DispatchQueue.main.async {
//                        DatabaseManager.shared.deleteAll()
//                        for post in posts{
//                            DatabaseManager.shared.insertData(postModel: post)
//                        }
//                        let newPost = DatabaseManager.shared.retrieveData()
//                        print("inserted posts: \(newPost.count )")
//                    }
//
                    print("Received posts: \(posts.count )")
                } else {
                    print("Failed to decode response")
                }
            case .failure:
                print("Error perform network request")
            }
        }
    }
}
