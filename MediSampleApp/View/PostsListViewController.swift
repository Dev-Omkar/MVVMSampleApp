//
//  PostsListViewController.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//
import UIKit

class PostsListViewController: UIViewController,UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        employeeViewModel.filter(seachValue: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        employeeViewModel.filter(seachValue: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func logoutAction(_ sender: Any) { 
        employeeViewModel.performLogout { (response) in
            switch(response){
            case .success(let responseModel):
                if responseModel.success{
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    //show message
                }
                break
            case .failure(let _):
                //show message
                break
            }
        }
    }
    @IBOutlet weak var employeeTableView: UITableView!
    
    private var employeeViewModel : EmployeesViewModel!
    
    private var dataSource : EmployeeTableViewDataSource<PostViewCell,PostDataModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.employeeTableView.tableFooterView = UIView.init()
        self.employeeViewModel =  EmployeesViewModel()
        employeeViewModel.callFuncToGetEmpData()
        callToViewModelForUIUpdate() 
    }
    override func viewDidAppear(_ animated: Bool) {
        employeeViewModel.reloadFromDb()
    }
    func callToViewModelForUIUpdate(){
        employeeTableView.keyboardDismissMode = .onDrag
        
        self.employeeTableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "PostViewCell")
        self.employeeTableView.delegate = self
        
        self.employeeViewModel.bindEmployeeViewModelToController = {
            self.updateDataSource()
        }
        
    }
    
    func updateDataSource(){
        
        self.dataSource = EmployeeTableViewDataSource(cellIdentifier: "PostViewCell", items: self.employeeViewModel.empData, configureCell: { (cell, evm) in
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

extension PostsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.employeeViewModel.addToFavourite(indexNumber: indexPath.row)
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
