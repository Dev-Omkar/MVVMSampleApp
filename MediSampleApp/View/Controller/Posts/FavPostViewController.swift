//
//  FavPostViewController.swift
//  MediSampleApp
//
//  Created by MacStar on 27/09/21.
//

import UIKit

class FavListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var employeeTableView: UITableView!
    private var postViewModel : PostListViewModel!
    private var dataSource : EmployeeTableViewDataSource<PostViewCell,PostDataModel>!
    
    //MARK:- View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.employeeTableView.tableFooterView = UIView.init()
        callToViewModelForUIUpdate()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        postViewModel.loadDataFromDB() 
    }
    
    //MARK:- Actions
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
                    AlertHelper.showAlert(title: "Alert", message: error.localizedDescription, over:  currentSelf)
                }
                break
            }
        }
        
    }
    
    //MARK:- Helpers
    func callToViewModelForUIUpdate(){
        employeeTableView.keyboardDismissMode = .onDrag
        self.postViewModel =  PostListViewModel()
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
}

extension FavListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.postViewModel.addToFavourite(indexNumber: indexPath.row)
        postViewModel.loadDataFromDB()
    }
}



extension FavListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        postViewModel.filter(seachValue: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        postViewModel.filter(seachValue: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
