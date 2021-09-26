//
//  PotListViewModel.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class PotListViewModel{
     
    let items = Observable<[PostModel]>([])
    let error = Observable<Error?>(nil)
   
     
    private let apiManager: ApiService
    init(dataManager: ApiService) {
        self.apiManager = dataManager
    }
    
    func fetchData() { 
        RepositoryManager.sharedInstance.getPosts {  [weak self] (result) in
            switch(result){
            case .success(let model): 
                self?.items.value = model
            case .failure(let error):
                self?.error.value = error
            }
        }
        
        
    }
    
}
import Foundation

class EmployeesViewModel : NSObject {
    var error :Error? = nil
    private var apiService : ApiService!
    private(set) var empData : [PostModel]! {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
    
    var bindEmployeeViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  ApiService()
        callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
        RepositoryManager.sharedInstance.getPosts {  [weak self] (result) in
            switch(result){
            case .success(let model):
                self?.empData = model
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
