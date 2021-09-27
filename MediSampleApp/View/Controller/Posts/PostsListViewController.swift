//
//  PostsListViewController.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//
import UIKit

class PostListViewController: UIViewController,UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        postViewModel.filter(seachValue: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        postViewModel.filter(seachValue: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func logoutAction(_ sender: Any) { 
        postViewModel.performLogout { [weak self] (response) in
            switch(response){
            case .success(let responseModel):
                if responseModel.success{
                    self?.navigationController?.popToRootViewController(animated: true)
                }else{
                    if let currentSelf = self{
                    AlertHelper.showAlert(title: "Alert", message: responseModel.message, over:  currentSelf)
                    }
                }
                break
            case .failure(let error):
                if let currentSelf = self{
                    AlertHelper.showAlert(title: "Alert", message:error.localizedDescription, over:  currentSelf)
                }
                break
            }
        }
    }
    @IBOutlet weak var employeeTableView: UITableView!
    
    private var postViewModel : PostListViewModel!
    
    private var dataSource : EmployeeTableViewDataSource<PostViewCell,PostDataModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.employeeTableView.tableFooterView = UIView.init()
        self.postViewModel =  PostListViewModel()
        postViewModel.callFuncToGetpostDataList()
        callToViewModelForUIUpdate() 
    }
    override func viewDidAppear(_ animated: Bool) {
        postViewModel.reloadFromDb()
    }
    func callToViewModelForUIUpdate(){
        employeeTableView.keyboardDismissMode = .onDrag
        self.postViewModel.isLoading.bind(){ value in
            DispatchQueue.main.async {
                if value{
                    SwiftLoader.show(title: "Loading...", animated: true)
                }else{
                    SwiftLoader.hide()
                }
            }  
        }
        self.employeeTableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "PostViewCell")
        self.employeeTableView.delegate = self
        
        self.postViewModel.bindEmployeeViewModelToController = {
            self.updateDataSource()
        }
        
    }
    
    func updateDataSource(){
        
        self.dataSource = EmployeeTableViewDataSource(cellIdentifier: "PostViewCell", items: self.postViewModel.postDataList, configureCell: { (cell, evm) in
            cell.titleTextLabel.text = evm.title
            cell.bodyTextLabel.text = evm.body
            if evm.isFavourite{
                cell.favImage.setImage(UIImage.init(named: "like"), for: .normal)
            }else{
                cell.favImage.setImage(UIImage.init(named: "dislike"), for: .normal)
            } 
        })
        
        DispatchQueue.main.async {
            self.employeeTableView.dataSource = self.dataSource
            self.employeeTableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension PostListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.postViewModel.addToFavourite(indexNumber: indexPath.row)
    }
}

class EmployeeTableViewDataSource<Cell :PostViewCell,ViewModel> : NSObject, UITableViewDataSource {
    
    private var cellIdentifier :String!
    private var items :[ViewModel]!
    var configureCell :(Cell,ViewModel) -> ()
    
    init(cellIdentifier :String, items :[ViewModel], configureCell: @escaping (Cell,ViewModel) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        let item = self.items[indexPath.row]
        self.configureCell(cell,item)
        return cell
    }
    
    
}
