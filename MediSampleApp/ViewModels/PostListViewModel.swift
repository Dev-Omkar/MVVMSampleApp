//
//  PotListViewModel.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
 
import Foundation

class PostListViewModel : NSObject {
    var error :Error? = nil
    private var apiService : ApiService!
    private(set) var originalData  : [PostDataModel]!
    private(set) var empData : [PostDataModel]! {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
    
    func filter(seachValue:String){
        empData = seachValue.isEmpty ? originalData : originalData.filter { $0.title.lowercased().contains(seachValue.lowercased()) }
    }
    var shouldRefresh: Observable<Bool> = Observable(false)
    
    var bindEmployeeViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  ApiService()
        
    }
    func performLogout(completion:@escaping (Result<LogoutResponseModel, URLError>)-> Void){
        apiService.postLogout { (response) in
            SessionData.email = ""
            SessionData.password = ""
            SessionData.isUserLoggedIn = false
            completion(response)
        }
    }
    func callFuncToGetEmpData() {
        RepositoryManager.sharedInstance.getPosts {  [weak self] (result) in
            switch(result){
            case .success(let models):
                self?.originalData = models
                self?.empData = models
            case .failure(let error):
                self?.error = error
            }
        }
    }
    func reloadFromDb(){
        let favData = DatabaseManager.shared.retrieveFavData()
        let ids = favData.map { $0.id }
        if let empData = self.empData{
        for (index,data) in empData.enumerated(){
            var newData = data
            if ids.contains(data.id){
                newData.isFavourite = true
            }else{
                newData.isFavourite = false
            }
            self.empData[index] = newData
        }
        }
        
    }
    
    func loadDataFromDB(){
        let data = DatabaseManager.shared.retrieveFavData()
        self.empData = data
        self.originalData = data
    }
    
    
    func addToFavourite(indexNumber:Int){
        
        for (index,data) in empData.enumerated(){
            var newData = data
            if index == indexNumber {
                if data.isFavourite == true{
                    newData.isFavourite = false
                }else{
                    newData.isFavourite = true
                }
                empData[index] = newData
                shouldRefresh.value = true
                DatabaseManager.shared.updateFavourite(isFav: newData.isFavourite, id: newData.id)
               
                break
            }
        }
    }
}
