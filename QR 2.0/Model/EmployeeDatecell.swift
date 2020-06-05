//
//  EmployeeDatecell.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/29/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import UIKit

class EmployeeDatecell: UITableViewCell {

    
    @IBOutlet weak var AddTimesButton: UIButton!
    @IBOutlet weak var DayLabel: UILabel!
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var StartPicker: UIDatePicker!
    @IBOutlet weak var EndPicker: UIDatePicker!
    @IBOutlet weak var StartLabel: UILabel!
    @IBOutlet weak var EndLabel: UILabel!
    @IBOutlet weak var CheckImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        self.StartPicker.isHidden = true
        self.EndPicker.isHidden = true
        self.StartLabel.isHidden = true
        self.EndLabel.isHidden = true
        self.CheckImage.isHidden = true
        self.AddTimesButton.isHidden = true
        super.awakeFromNib()
        GlobalFunctions.setButtonRadius(button: self.AddTimesButton)
        
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
        self.StartPicker.isHidden = true
        self.EndPicker.isHidden = true
        self.StartLabel.isHidden = true
        self.EndLabel.isHidden = true
        self.CheckImage.isHidden = true
        self.AddTimesButton.isHidden = true
        self.Switch.isOn = false

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func OnSwitch(_ sender: UISwitch) {
        if self.Switch.isOn {
            self.StartPicker.isHidden = false
            self.EndPicker.isHidden = false
            self.StartLabel.isHidden = false
            self.EndLabel.isHidden = false
            self.AddTimesButton.isHidden = false
            

            if self.DayLabel.text == GlobalVariables.UserIDs.mondayString  {
                GlobalVariables.ActualIDs.mondayIsOn = true
            }
            
            if self.DayLabel.text == GlobalVariables.UserIDs.tuesdayString  {
                GlobalVariables.ActualIDs.tuesdayIsOn = true
            }
            
            if self.DayLabel.text == GlobalVariables.UserIDs.wednesdayString  {
                GlobalVariables.ActualIDs.wednesdayIsOn = true
            }
            
            if self.DayLabel.text == GlobalVariables.UserIDs.thursdayString  {
                GlobalVariables.ActualIDs.thursdayIsOn = true
            }
            
            if self.DayLabel.text == GlobalVariables.UserIDs.fridayString  {
                GlobalVariables.ActualIDs.fridayIsOn = true
            }
            
            if self.DayLabel.text == GlobalVariables.UserIDs.saturdayString  {
                GlobalVariables.ActualIDs.saturdayIsOn = true
            }
            
            if self.DayLabel.text == GlobalVariables.UserIDs.sundayString  {
                GlobalVariables.ActualIDs.sundayIsOn = true
            }
            
            
        }
        
        else {
            self.StartPicker.isHidden = true
            self.EndPicker.isHidden = true
            self.StartLabel.isHidden = true
            self.EndLabel.isHidden = true
            self.CheckImage.isHidden = true
            self.AddTimesButton.isHidden = true
        }
        
    }
    
    
    @IBAction func AddTimes(_ sender: UIButton) {
        
        //set the global variables as the same time displayed on the picker
               if GlobalVariables.ActualIDs.mondayIsOn == true {
                 let formatter = DateFormatter()
                 formatter.dateStyle = .none
                 formatter.dateFormat = "HH:mm"
                
                
                GlobalVariables.ActualIDs.mondayStartTime = formatter.string(from: self.StartPicker.date)
                GlobalVariables.ActualIDs.mondayEndTime = formatter.string(from: self.EndPicker.date)
               }
               
        
               if GlobalVariables.ActualIDs.tuesdayIsOn == true {
                
                let formatter = DateFormatter()
                 formatter.dateStyle = .none
                 formatter.dateFormat = "HH:mm"
                
                
                 GlobalVariables.ActualIDs.tuesdayStartTime = formatter.string(from: self.StartPicker.date)
                 GlobalVariables.ActualIDs.tuesdayEndTime = formatter.string(from: self.EndPicker.date)
               }
               
               if GlobalVariables.ActualIDs.wednesdayIsOn == true  {
                
               let formatter = DateFormatter()
                 formatter.dateStyle = .none
                 formatter.dateFormat = "HH:mm"
                
                
                  GlobalVariables.ActualIDs.wednesdayStartTime = formatter.string(from: self.StartPicker.date)
                  GlobalVariables.ActualIDs.wednesdayEndTime = formatter.string(from: self.EndPicker.date)
               }
               
               if GlobalVariables.ActualIDs.thursdayIsOn == true {
                   let formatter = DateFormatter()
                    formatter.dateStyle = .none
                    formatter.dateFormat = "HH:mm"
                   
                   
                    GlobalVariables.ActualIDs.thursdayStartTime = formatter.string(from: self.StartPicker.date)
                    GlobalVariables.ActualIDs.thursdayEndTime = formatter.string(from: self.EndPicker.date)
               }
               
               if GlobalVariables.ActualIDs.fridayIsOn == true {
                   let formatter = DateFormatter()
                    formatter.dateStyle = .none
                    formatter.dateFormat = "HH:mm"
                   
                   
                    GlobalVariables.ActualIDs.fridayStartTime = formatter.string(from: self.StartPicker.date)
                    GlobalVariables.ActualIDs.fridayEndTime = formatter.string(from: self.EndPicker.date)
               }
               
               if GlobalVariables.ActualIDs.saturdayIsOn == true{
                   let formatter = DateFormatter()
                    formatter.dateStyle = .none
                    formatter.dateFormat = "HH:mm"
                   
                   
                    GlobalVariables.ActualIDs.saturdayStartTime = formatter.string(from: self.StartPicker.date)
                    GlobalVariables.ActualIDs.saturdayEndTime = formatter.string(from: self.EndPicker.date)
               }
               
               if GlobalVariables.ActualIDs.sundayIsOn == true {
                   let formatter = DateFormatter()
                   formatter.dateStyle = .none
                   formatter.dateFormat = "HH:mm"
                  
                   
                    GlobalVariables.ActualIDs.sundayStartTime = formatter.string(from: self.StartPicker.date)
                    GlobalVariables.ActualIDs.sundayEndTime = formatter.string(from: self.EndPicker.date)
               }
        
        
        self.CheckImage.isHidden = false
        
    }
    
 
    
}
