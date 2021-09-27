//
//  ApiManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class ApiService{
    
    static var sharedInstance = ApiService.init()
    
    func postLogin(email:String,
                   password:String,
                   completion:@escaping (Result<LoginResponseModel, ApiError>)-> Void){
        var model  = LoginResponseModel.init()
        model.data = LoginModel.init(email:email,password:password)
        completion(.success(model))
    }
    
    func postLogout(completion:@escaping (Result<LogoutResponseModel, ApiError>)-> Void){
        var model  = LogoutResponseModel.init()
        model.data = LoginModel.init(email:"",password:"")
        completion(.success(model))
    }
    
    func getPosts(completion:@escaping (Result<[PostModel], ApiError>)-> Void){
        let request = ApiRequest(method: .get, path: ApiEndpoint.posts.rawValue)
        ApiClient().perform(request) { (result) in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: [PostModel].self) {
                    let posts = response.body
                    completion(.success(posts))  
                } else {
                    completion(.failure(ApiError.decodingFailure))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
