//
//  EmployeeHome.swift
//  FizzyPoints
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

    
    
     
    var ScanButton = UIButton()
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        self.locationManager.startUpdatingLocation()
        setupView()
        
        
         navigationController?.navigationBar.titleTextAttributes =
                    [NSAttributedString.Key.foregroundColor: UIColor.systemPurple,
                    NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 25)!]
        self.parent?.title = String(describing: Auth.auth().currentUser?.email!)
        self.navigationItem.title = String(describing: Auth.auth().currentUser?.email!)
            
               navigationController?.navigationBar.barTintColor = .white
               navigationController?.navigationBar.tintColor = .systemPurple
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.coordinatesArray.append(self.locationManager.location!.coordinate)
        GlobalFunctions.setButtonRadius(button: self.ScanButton)
        self.navigationItem.hidesBackButton = true
       
        ScanButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2.5, height: 53)
        ScanButton.center = self.view.center
        
        navigationController?.navigationBar.titleTextAttributes =
             [NSAttributedString.Key.foregroundColor: UIColor.systemPurple,
             NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 25)!]
        
        self.navigationItem.title = String(describing: Auth.auth().currentUser?.email!)
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .systemPurple
        
    }
    
    //setup view
    func setupView() {
        ScanButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 100)
        ScanButton.center = self.view.center
        ScanButton.backgroundColor = .purple
        ScanButton.titleLabel?.font =  UIFont(name: "Poppins-Bold", size: 15)
        ScanButton.setTitleColor(.white, for: .normal)
        ScanButton.setTitle("Scan", for: .normal)
        B_1Register.setupShadow(view: ScanButton)
        ScanButton.addTarget(self, action: #selector(ScanAction), for: .touchUpInside)
        self.view.addSubview(ScanButton)
    }
    
    //MARK:- Actions
    @objc func ScanAction() {
        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.toCameraScreen, sender: self)
    }

    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        logoutAlert(title: "Logout?", message: nil)
    }
    
    
    //MARK:- Alerts
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
    
    
    
    //MARK: - Supplimentary functions
    func logoutProximity() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: false)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    //function to update the users current location
    //if the user has changed locations then log him/her out
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let mostRecentLocation = locations.last else {
        return
      }
        //.001
        
        ///when the user first logs in, he/she will only be able to do so IF they are close to their business.
        ///once the user has left the proximity from which he/she has logged into, they will automatically be logged off.
        
        
        ///these values below: - .0003 might need ot be changed.
        ///they represent the users safety zone in which they can still be logged in.
        ///in other words, if they leave a zone of .0003 by .0003 in coordinate points, they will be logged off.
        switch mostRecentLocation.coordinate.longitude {
            
        case self.coordinatesArray.first!.longitude - 0.0003 ... self.coordinatesArray.first!.longitude + 0.0003:
            //print(self.coordinatesArray.first!.longitude - mostRecentLocation.coordinate.longitude)
            return
            
        default:
            self.locationManager.stopUpdatingLocation()
            self.logoutProximity()
            
        }
            
      
 
      if UIApplication.shared.applicationState == .active {
      } else {
        print("App is backgrounded. New location is %@", mostRecentLocation)
      }
        
    }
  
}
    
    

