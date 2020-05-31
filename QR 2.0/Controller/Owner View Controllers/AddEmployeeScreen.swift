//
//  AddEmployeeScreen.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/29/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddEmployeeScreen : UIViewController{
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var DatesTableView: UITableView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    var DayOfWeekCellArray : [ShiftCellObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTableViewWithCells()
    }
    
    //set the labels for each cell as days of the week
    func fillDatesTableViewArray () {
        //fill up the array with enw objects
        for values in 0...6 {
            //make a new shift cell object with the label as the day of the week
            let shiftCell = ShiftCellObject(dayOfWeek: GlobalVariables.UserIDs.daysofWeekArray[values])
            DayOfWeekCellArray.append(shiftCell)
        }
    }
    
    //funciton to populate the array, then show it to the view
    func populateTableViewWithCells() {
        fillDatesTableViewArray()
        DatesTableView.dataSource = self
        DatesTableView.register(UINib(nibName: GlobalVariables.UserIDs.EmployeeDateCelltitle, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.DateViewCellForEmployeeID)
        DatesTableView.rowHeight = 200
        
    }
    
    //function to create said employee's shifts and whatnot.
    func createNewEmployeeShiftCollection() {
        
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.mondayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.mondayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.mondayEndTime])
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.tuesdayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.tuesdayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.tuesdayEndTime])
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.wednesdayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.wednesdayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.wednesdayEndTime])
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.thursdayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.thursdayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.thursdayEndTime])
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.fridayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.fridayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.fridayEndTime])
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.saturdayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.saturdayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.saturdayEndTime])
        
        GlobalFunctions.addEmployee(nameofUser: GlobalVariables.ActualIDs.CurrentUser!, employeeName: self.NameField.text!, employeeEmail: self.EmailField.text!, employeePassword: self.PasswordField.text!, workDay: GlobalVariables.UserIDs.sundayString, workShift: [GlobalVariables.UserIDs.startStringTime : GlobalVariables.ActualIDs.sundayStartTime , GlobalVariables.UserIDs.endStringTime : GlobalVariables.ActualIDs.sundayEndTime])
       
        
        
        
       
    }
    
    //function to add the users email and password to the authentication system
    func createNewEmployeeAsUser() {
        
        GlobalVariables.ActualIDs.ActualEmail = self.EmailField.text!
        GlobalVariables.ActualIDs.ActualUserType = GlobalVariables.UserIDs.UserEmployee
        
        Auth.auth().createUser(withEmail: self.EmailField.text!, password: self.PasswordField.text!) { (user, error) in
                   if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
                   else {
                       print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a \(GlobalVariables.ActualIDs.ActualUserType!)")
                          self.createNewEmployeeShiftCollection()
                          self.navigationController?.popViewController(animated: true)

                   }
               }
        
    }
    
    //button to officially create a new employee
    @IBAction func CreateEmployeeButton(_ sender: UIButton) {
        createNewEmployeeAsUser()
    }
    
    
}

//extension for the table to load the employess
extension AddEmployeeScreen : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //we want 7 cells
        return DayOfWeekCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DatesTableView.dequeueReusableCell(withIdentifier: GlobalVariables.UserIDs.DateViewCellForEmployeeID, for: indexPath) as! EmployeeDatecell
        cell.DayLabel.text = self.DayOfWeekCellArray[indexPath.row].dayOfWeek
        cell.StartPicker.isHidden = true
        cell.EndPicker.isHidden = true
        cell.StartLabel.isHidden = true
        cell.EndLabel.isHidden = true
        cell.CheckImage.isHidden = true
       
        
        return cell
        
    }
    
    

    
    
}
