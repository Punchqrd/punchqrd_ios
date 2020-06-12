//
//  EmployeeHome.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/8/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import GooglePlaces
import MapKit

class EmployeeHome: UIViewController, CLLocationManagerDelegate{

    
    var coordinatesArray : [CLLocationCoordinate2D] = []
    private lazy var locationManager: CLLocationManager = {
       let manager = CLLocationManager()
       manager.desiredAccuracy = kCLLocationAccuracyBest
       manager.delegate = self
       manager.requestAlwaysAuthorization()
       manager.allowsBackgroundLocationUpdates = true
       return manager
     }()

     
    
    @IBOutlet weak var ScanButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        
        if CLLocationManager.authorizationStatus() == .notDetermined
               {
                   locationManager.requestWhenInUseAuthorization()
                   locationManager.delegate = self
                   locationManager.startUpdatingLocation()
                   locationManager.requestAlwaysAuthorization()
                   
               }
               
        self.locationManager.delegate = self
        let firstLocation = self.locationManager.location!.coordinate
        self.coordinatesArray.append(firstLocation)
        print(firstLocation.longitude)
        
        

        self.locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.coordinatesArray.append(self.locationManager.location!.coordinate)
        GlobalFunctions.setButtonRadius(button: self.ScanButton)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        
        
    }
    
    @IBAction func ScanAction(_ sender: UIButton) {
        
        
    }
    
    
    
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        
        logoutAlert(title: "Logout?", message: nil)
    }
    
    
    
    //logout alert
    func logoutAlert(title : String?, message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.navigationController?.popToRootViewController(animated: false)
                print("Logged out the user")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    //MARK: - function to logout the current user if he/she has left proximity.
    
   
    func logoutProximity() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            //reset the values for the user defaults as false to indicate that the user is logged out
            
            self.navigationController?.popToRootViewController(animated: false)
            
            
            print("Logged out the user")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
    //MARK: - Function to update the users current location.
    
    //if the user has changed locations then log him/her out
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let mostRecentLocation = locations.last else {
        return
      }
        //.001
       
        
        switch mostRecentLocation.coordinate.longitude {
        case self.coordinatesArray.first!.longitude - 0.0003 ... self.coordinatesArray.first!.longitude + 0.0003:
            print(self.coordinatesArray.first!.longitude - mostRecentLocation.coordinate.longitude)
        default:
            print("Logged off")
            
                       self.locationManager.stopUpdatingLocation()
                       self.logoutProximity()
            
            print(mostRecentLocation.coordinate.longitude - self.coordinatesArray.first!.longitude)
        }
            
      
 
      if UIApplication.shared.applicationState == .active {
      } else {
        print("App is backgrounded. New location is %@", mostRecentLocation)
      }
        
    }
  
}
    
    

