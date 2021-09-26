//
//  PostsListViewController.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//
import UIKit
 
class PostsListViewController: UIViewController {
    
    
    @IBOutlet weak var employeeTableView: UITableView!
    
    private var employeeViewModel : EmployeesViewModel!
    
    private var dataSource : EmployeeTableViewDataSource<PostViewCell,PostModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        self.employeeTableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "PostViewCell")
        
        self.employeeViewModel =  EmployeesViewModel()
        self.employeeViewModel.bindEmployeeViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        
        self.dataSource = EmployeeTableViewDataSource(cellIdentifier: "PostViewCell", items: self.employeeViewModel.empData, configureCell: { (cell, evm) in
            //     cell.titleTextLabel.text = "1"
            cell.titleTextLabel.text = evm.title
            cell.bodyTextLabel.text = evm.body
        })
        
        DispatchQueue.main.async {
            self.employeeTableView.dataSource = self.dataSource
            self.employeeTableView.reloadData()
        }
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
