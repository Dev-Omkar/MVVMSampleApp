//
//  PotListViewModel.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
 
import Foundation

class PostListViewModel : NSObject {
    
    
    private(set) var originalData  : [PostDataModel]!
    private(set) var postDataList : [PostDataModel]! {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
     
    var isLoading: Observable<Bool> = Observable(false)
    var bindEmployeeViewModelToController : (() -> ()) = {}
     
    override init() {
        super.init()
        
        
    }
    func performLogout(completion:@escaping (Result<LogoutResponseModel, ApiError>)-> Void){
        ApiService.sharedInstance.postLogout { (response) in
            SessionData.email = ""
            SessionData.password = ""
            SessionData.isUserLoggedIn = false
            DatabaseManager.shared.deleteAll()
            completion(response)
        }
    }
    func callFuncToGetpostDataList() {
        isLoading.value = true
        RepositoryManager.sharedInstance.getPosts {  [weak self] (result) in
            switch(result){
            case .success(let models):
                self?.originalData = models
                self?.postDataList = models
                self?.isLoading.value = false
            case .failure:
                self?.isLoading.value = false 
            }
        }
        
        
    }
    func reloadFromDb(){
        let favData = DatabaseManager.shared.getFavPostsData()
        let ids = favData.map { $0.id }
        if let dataList = self.postDataList{
            for (index,data) in dataList.enumerated(){
                var newData = data
                if ids.contains(data.id){
                    newData.isFavourite = true
                }else{
                    newData.isFavourite = false
                }
                self.postDataList[index] = newData
            }
        }
        
        if let ogList = self.originalData{
            for (index,data) in ogList.enumerated(){
                var newData = data
                if ids.contains(data.id){
                    newData.isFavourite = true
                }else{
                    newData.isFavourite = false
                }
                self.originalData[index] = newData
            }
        }
        
    }
    //MARK:-  Helpers
    func filter(seachValue:String){
        postDataList = seachValue.isEmpty ? originalData : originalData.filter { $0.title.lowercased().contains(seachValue.lowercased()) }
    }
    
    
    func loadDataFromDB(){
        let data = DatabaseManager.shared.getFavPostsData()
        self.postDataList = data
        self.originalData = data
    }
    
    
    func addToFavourite(indexNumber:Int){
        
        for (index,data) in postDataList.enumerated(){
            var newData = data
            if index == indexNumber {
                if data.isFavourite == true{
                    newData.isFavourite = false
                }else{
                    newData.isFavourite = true
                }
                updateInMain(id: newData.id, value: newData.isFavourite)
                postDataList[index] = newData
                
                DatabaseManager.shared.updatePostFavStatus(isFav: newData.isFavourite, id: newData.id)
               
                break
            }
        }
    }
    func updateInMain(id:Int,value:Bool){
        if let ogList = self.originalData{
        for (ogIndex,ogdata) in ogList.enumerated(){
            var ogNewData = ogdata
            if ogNewData.id == id{
                ogNewData.isFavourite = value
                self.originalData[ogIndex] = ogNewData
                break
            }
           
          
        }
    }
    }
}
