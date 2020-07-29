//
//  RemoveEmployeesScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/5/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RemoveEmployeesScreen : UIViewController, UITableViewDelegate {
    
    var employeeArray : [EmployeeObject] = []
    
    var EmployeeTable = UITableView()
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        EmployeeTable.delegate = self
        navigationController?.navigationBar.titleTextAttributes =
                     [NSAttributedString.Key.foregroundColor: UIColor.systemPurple,
                     NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 25)!]
                
        navigationItem.title = "Employee List"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //when the view appears, create a new list of the employees in the collection.
        EmployeeTable.frame = self.view.frame
        EmployeeTable.separatorStyle = .none
        self.view.addSubview(EmployeeTable)
        EmployeeTable.dataSource = self
        showList()
    }
    
    //MARK:- Tableview Refresher Functions
    func refreshData() {
        self.EmployeeTable.reloadData()
        DispatchQueue.main.async { self.EmployeeTable.reloadData() }
        createNewEmployeeList()
        EmployeeTable.dataSource = self
        EmployeeTable.register(UINib(nibName: GlobalVariables.UserIDs.EmployeeNibCellID, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.EmployeeTableCellID)
        
    }
    
    func showList() {
        print("Show list is called")
        createNewEmployeeList()
        EmployeeTable.dataSource = self
        EmployeeTable.register(UINib(nibName: GlobalVariables.UserIDs.EmployeeNibCellID, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.EmployeeTableCellID)
        EmployeeTable.rowHeight = 130
        
    }
    
    //MARK:- Table View Logic
    func createNewEmployeeList() {
        self.employeeArray = []
        //access the database
        let db = Firestore.firestore()
        //specify the correct path to the collection set
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.EmployeeList).getDocuments { (Employees, error) in
            if let error = error {print(error)}
                
            else {
                for people in Employees!.documents {
                    //make a new object of each employee in the collection
                    let newEmployee = EmployeeObject(name: (people.get(GlobalVariables.UserIDs.EmployeeNameString) as! String), password: (people.get(GlobalVariables.UserIDs.EmployeePasswordString) as! String), email: people.documentID)
                    self.employeeArray.append(newEmployee)
                    print(newEmployee.name!)
                    DispatchQueue.main.async { self.EmployeeTable.reloadData() }
                    self.EmployeeTable.reloadData()
                    
                }
            }
        }
    }
    
    //MARK:- Alerts
    func createBottomAlert(title : String?, message : String?, valueRemove : Int, path : IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            //function to delete employee from database
            GlobalFunctions.deleteEmployeeFromBusiness(nameOfFile: self.employeeArray[valueRemove].email!)
            self.employeeArray.remove(at: valueRemove)
            self.EmployeeTable.deleteRows(at: [path], with: .fade)
            //insert the function to delete a piece of data from the collection
            self.EmployeeTable.reloadData()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    
}

//MARK:- Extension for TableView
extension RemoveEmployeesScreen: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EmployeeTable.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.EmployeeTableCellID, for: indexPath) as! EmployeeCell
        cell.NameLabel.text = self.employeeArray[indexPath.row].name
        cell.EmailLabel.text = "Email: \(String(describing: self.employeeArray[indexPath.row].email!))"
        cell.PasswordLabel.text = "Password: \(String(describing: self.employeeArray[indexPath.row].password!))"
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        cell.frame.size.width = EmployeeTable.frame.size.width
        
        return cell
    }
    
    //disable full swipe accross cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.createBottomAlert(title: "Remove this Employee?", message: "To finalize the process, please sign out, and sign back in as the user you are about to delete.", valueRemove: indexPath.row, path: indexPath)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
        
    }
    
    
    
    
}
