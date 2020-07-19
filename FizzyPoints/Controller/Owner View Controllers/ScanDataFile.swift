//
//  ScanDataFile.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/7/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class ScanDataFile : UIViewController {
    
    private lazy var animationView1: AnimationView = {
      let view = AnimationView()
      return view
    }()
    
    private lazy var animationView2: AnimationView = {
      let view = AnimationView()
      return view
    }()
    
    private lazy var animationView3: AnimationView = {
      let view = AnimationView()
      return view
    }()
    

    
    var businessDataHolder : [OwnerDataObject] = []
    var toggleValue = true
    //view variables
    let bottomView = UIView()
    let middleView = UIView()
    
    let totalScansView = UIView()
    let totalScansValue = UILabel()
    
    let averageRevenueView = UIView()
    let averageRevenueLabel = UILabel()
    
    let totalRevenueView = UIView()
    let totalRevenueLabel = UILabel()
    
    let switchButton = UIButton()
    
    //all for the left views
    let leftView = UIView()
    let leftViewTitle = UILabel()
    
   
    //MARK:-View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.setupSideView()
        }
               
        retrieveValuesFromDataBase()
        
        
        
        //setup the data when the view loads.
        //must include some sort of guard if the internet is poor.
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leftView.removeFromSuperview()
    }
    
    
    
    //MARK:- Suplimentary functions
    
    func retrieveValuesFromDataBase() {
        
        let db = Firestore.firestore()
        let totals = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.ScanDataString).document(GlobalVariables.UserIDs.TotalScansString)
        totals.getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                let retrievedRevenue = doc.get(GlobalVariables.UserIDs.OwnerRevenueString) as! Double
                let retrievedScans = doc.get(GlobalVariables.UserIDs.CustomerPurchasesString) as! Double
                let averageRevenue = retrievedRevenue/retrievedScans
                
                
                let newData = OwnerDataObject(totalScans: Int(retrievedScans), totalRevenue: retrievedRevenue, totalRedemptions: 0, averageRevenue: averageRevenue)
                self.businessDataHolder.append(newData)
                
                
                self.totalScansValue.text = String(describing: self.businessDataHolder[0].totalScans!)
                self.totalRevenueLabel.text = "$\(String(describing: self.businessDataHolder[0].totalRevenue!.rounded(toPlaces: 2)))"
                self.averageRevenueLabel.text = "$\(String(describing: self.businessDataHolder[0].averageRevenue!.rounded(toPlaces: 2)))"
                
                //animate the values
                self.animationView1.removeFromSuperview()
                self.animationView2.removeFromSuperview()
                self.animationView3.removeFromSuperview()

                
            } else {
                self.businessDataHolder.append(OwnerDataObject(totalScans: 0, totalRevenue: 0, totalRedemptions: 0, averageRevenue: 0))
                
                self.totalScansValue.text = String(describing: self.businessDataHolder[0].totalScans!)
                self.totalRevenueLabel.text = "$0"
                self.averageRevenueLabel.text = "$0"
                
                self.animationView1.removeFromSuperview()
                self.animationView2.removeFromSuperview()
                self.animationView3.removeFromSuperview()

                
                
            }
            
            
        }
    }
    
    //function to setup the views.
    //first view to setup is the middle view
    func setupMiddleView() {
        //setup the middle container view
        middleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/1.2, height: self.view.frame.size.height/1.4)
        middleView.center.x = self.view.frame.size.width/2
        middleView.center.y = self.view.center.y
        middleView.backgroundColor = .white
        self.view.addSubview(middleView)
        setupTotalScansView(parentView: middleView)
        setupTotalRevenueView(parentView: middleView)
        setupAverageRevenueView(parentView: middleView)
        
        
        //setup the bottom view
        bottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - middleView.frame.size.height - 150)
        bottomView.center.x = self.view.center.x
        bottomView.center.y = self.view.frame.size.height - bottomView.frame.size.height/2
        bottomView.backgroundColor = .white
        //setup the chevron button so that the user can switch to see all his/her customer data.
        setupSwitchButton(view: bottomView)
        self.view.addSubview(bottomView)
        
        
        //setup the input variables for the main view. (average, total, scans, etc.)
        
        
    }
    
    func setupSideView() {
        
        leftView.frame = self.middleView.frame
        leftView.center.x = -self.view.frame.size.width/2
        leftView.backgroundColor = .purple
        leftView.layer.cornerRadius = 30
        leftView.center.y = self.view.frame.size.height/2
        setupShadow(view: leftView)
        //setup a new line that creates a new instance of a table for the user to see
        //looks something like this
        /*
         let chartView = customersClass(currentuseremail, leftview, superview)
         leftview.addSubview(chartView)
     
         */
        let chartView = CustomerTable(currentUserEmail: Auth.auth().currentUser?.email!, leftView: leftView, superView: self.view!)
        chartView.populateData()
        
        self.leftView.addSubview(chartView)
        
        self.view.addSubview(leftView)
    }
    
    func setupSwitchButton(view: UIView) {
        let backGroundImage = UIImage(systemName: "chevron.left")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        switchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
        switchButton.center.x = view.frame.size.width/2
        switchButton.center.y = view.frame.size.height/2
        switchButton.setBackgroundImage(tintedImage, for: .normal)
        switchButton.tintColor = .black
        switchButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        
        
        view.addSubview(switchButton)
    }
    
    
    
    @objc func toggleView() {
        if toggleValue == true {
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                self.middleView.center.x = self.view.frame.size.width * 1.5
                self.switchButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.leftView.center.x = self.view.frame.size.width/2

                self.toggleValue = false
                
                
                
            }, completion: nil)
        } else {
            
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                self.middleView.center.x = self.view.frame.size.width/2
                self.switchButton.transform = CGAffineTransform.identity
                self.leftView.center.x = -self.view.frame.size.width/2
                self.toggleValue = true
                
                
                
            }, completion: nil)
        }
    }
    
    func setupTotalScansView(parentView: UIView) {
        totalScansView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        totalScansView.center.x = parentView.frame.size.width/4
        totalScansView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.9
        totalScansView.backgroundColor = .purple
        totalScansView.layer.cornerRadius = 30
        
        setupShadow(view: totalScansView)
        
        //setup the labels
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: 0, y: 0, width: totalScansView.frame.size.width, height: 30)
        totalLabel.center.x = totalScansView.frame.size.width/2
        totalLabel.center.y = totalScansView.frame.size.height/3.5
        totalLabel.text = "Total Scans"
        totalLabel.textColor = .white
        totalLabel.font =  UIFont(name: "Poppins-Bold", size: 15)
        totalLabel.textAlignment = .center
        totalScansView.addSubview(totalLabel)
        
        totalScansValue.frame = CGRect(x: 0, y: 0, width: totalScansView.frame.size.width, height: 40)
        totalScansValue.center.x = totalScansView.frame.size.width/2
        totalScansValue.center.y = totalScansView.frame.size.height - totalScansView.frame.size.height/2.2
        totalScansValue.textColor = .white
        totalScansValue.font =  UIFont(name: "Poppins-Bold", size: 30)
        totalScansValue.textAlignment = .center
        totalScansView.addSubview(totalScansValue)
        setupShadow(view: totalLabel)
        
        
        //setup the animation view
        
        
        setupAnimation(parentView: totalScansView, animationView: animationView3, animationName: "BeerLoader")

        parentView.addSubview(totalScansView)
        
        
        
    }
    
    func setupAnimation(parentView: UIView, animationView: AnimationView, animationName: String) {
        animationView.animation = Animation.named(animationName)
        animationView.frame = parentView.frame
        animationView.center.x = parentView.frame.width/2
        animationView.center.y = parentView.frame.height/2
        animationView.contentMode = .scaleAspectFit
        
        animationView.layer.cornerRadius = 30
        animationView.backgroundColor = .purple
        animationView.play()
        animationView.loopMode = .loop
        parentView.addSubview(animationView)
    }
    
    
    func setupTotalRevenueView(parentView: UIView) {
        totalRevenueView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        totalRevenueView.center.x = parentView.frame.size.width - totalRevenueView.frame.size.width/1.5
        totalRevenueView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.2
        
        totalRevenueView.backgroundColor = .purple
        totalRevenueView.layer.cornerRadius = 30
        
        setupShadow(view: totalRevenueView)
        
        //setup the labels
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: 0, y: 0, width: totalRevenueView.frame.size.width, height: 30)
        totalLabel.center.x = totalRevenueView.frame.size.width/2
        
        
        totalLabel.center.y = totalRevenueView.frame.size.height/3.5
        totalLabel.text = "Total Revenue"
        totalLabel.textColor = .white
        totalLabel.font =  UIFont(name: "Poppins-Bold", size: 15)
        totalLabel.textAlignment = .center
        totalRevenueView.addSubview(totalLabel)
        
        totalRevenueLabel.frame = CGRect(x: 0, y: 0, width: totalRevenueView.frame.size.width, height: 40)
        totalRevenueLabel.center.x = totalRevenueView.frame.size.width/2
        totalRevenueLabel.center.y = totalRevenueView.frame.size.height - totalRevenueView.frame.size.height/2.2
        totalRevenueLabel.textColor = .white
        totalRevenueLabel.font =  UIFont(name: "Poppins-Bold", size: 25)
        totalRevenueLabel.textAlignment = .center
        totalRevenueView.addSubview(totalRevenueLabel)
        setupShadow(view: totalLabel)
        
        
        
        
        
        
        setupAnimation(parentView: totalRevenueView, animationView: animationView2, animationName: "CoffeeLoader")


        parentView.addSubview(totalRevenueView)
        
        
    }
    
    
    func setupAverageRevenueView(parentView: UIView) {
        averageRevenueView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        averageRevenueView.center.x = parentView.frame.size.width/4
        averageRevenueView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.2
        
        averageRevenueView.backgroundColor = .purple
        averageRevenueView.layer.cornerRadius = 30
        
        setupShadow(view: averageRevenueView)
        
        //setup the labels
        let totalLabel = UILabel()
        totalLabel.frame = CGRect(x: 0, y: 0, width: averageRevenueView.frame.size.width, height: 30)
        totalLabel.center.x = averageRevenueView.frame.size.width/2
        totalLabel.center.y = averageRevenueView.frame.size.height/3.5
        totalLabel.text = "Average $/Scan"
        totalLabel.textColor = .white
        totalLabel.font =  UIFont(name: "Poppins-Bold", size: 15)
        totalLabel.textAlignment = .center
        averageRevenueView.addSubview(totalLabel)
        
        averageRevenueLabel.frame = CGRect(x: 0, y: 0, width: averageRevenueView.frame.size.width, height: 40)
        averageRevenueLabel.center.x = averageRevenueView.frame.size.width/2
        averageRevenueLabel.center.y = averageRevenueView.frame.size.height - averageRevenueView.frame.size.height/2.2
        averageRevenueLabel.textColor = .white
        averageRevenueLabel.font =  UIFont(name: "Poppins-Bold", size: 25)
        averageRevenueLabel.textAlignment = .center
        averageRevenueView.addSubview(averageRevenueLabel)
        setupShadow(view: totalLabel)
        
        
        
        
        
        setupAnimation(parentView: averageRevenueView, animationView: animationView1, animationName: "CroissantLoader")

        parentView.addSubview(averageRevenueView)
        
        
    }
    
    
    func setupShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.3
    }
    
    
    
    
    
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}





