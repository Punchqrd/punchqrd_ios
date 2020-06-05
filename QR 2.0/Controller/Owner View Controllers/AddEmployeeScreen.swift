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

class AddEmployeeScreen : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var DatesTableView: UITableView!
    
   
    
    var DayOfWeekCellArray : [ShiftCellObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        GlobalFunctions.setButtonRadius(button: self.CreateButton)
        populateTableViewWithCells()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
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
        DatesTableView.register(UINib(nibName: GlobalVariables.UserIDs.EmployeeDateCelltitle, bundle: nil), forCellReuseIdentifier: GlobalVariables.UserIDs.DateViewCellForEmployeeID)
        DatesTableView.dataSource = self
        DatesTableView.rowHeight = 200
        
    }
    
   
    
    //button to officially create a new employee
    @IBAction func CreateEmployeeButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.EmployeeSecondScreenSegue
            , sender: self)
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
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        print(cell.DayLabel.text)
        return cell
        
    }
    
    

    
    
}
