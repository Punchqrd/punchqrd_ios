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
    
    private lazy var graphAnimation: AnimationView = {
      let view = AnimationView()
      return view
    }()
    

    private lazy var backGroundView: UIView = {
        let backGroundView = UIView()
        backGroundView.frame = self.view.frame
        backGroundView.backgroundColor = .clear
        backGroundView.center = self.view.center
        return backGroundView
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
    private lazy var leftView: UIView = {
        let leftView = UIView()
        return leftView
    }()
    
    let leftViewTitle = UILabel()
    
    //rightview buttons and views
    let rightView = UIView()
    let rightViewLabel = UILabel()
    let rightViewButton = UIButton()
    
    var titleLabel = UILabel()
    var newRevenue = 0.0
    var newAverage = 0.0
    var totalScans = 0.0

    
    var newLeftSwipe = UISwipeGestureRecognizer()
    
   
    //MARK:-View functions
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        let newAnimation = graphAnimation
//        self.setupAnimationGraph(parentView: self.view, animationView: newAnimation, animationName: "17216-your-app-developer")
              
        setupMiddleView()
        setupRightViewButton()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.setupSideView()
            self.setupRightView()
//            self.setupSwipes()
            
        }
 
        retrieveValuesFromDataBase()
        setupToHideKeyboardOnTapOnView()
         
        
        
        
        //this is a function called below, with a completion handler that will change the values within the braces below to the values retrieved.
        setListenerForRevenue {
            ///when the completion handler is called, these labels will update to the appropriate values.
            self.totalRevenueLabel.text = String(describing: "$\(self.newRevenue)")
            self.averageRevenueLabel.text = String(describing: "$\((self.newRevenue/self.totalScans).rounded(toPlaces: 2))")
        }
        
        //set another listener function for customer total spent label.
        
        
        
        
        

        //Keyboard functions
              // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
              NotificationCenter.default.addObserver(self, selector: #selector(ScanDataFile.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                  
              // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
              NotificationCenter.default.addObserver(self, selector: #selector(ScanDataFile.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              
        
        //setup the data when the view loads.
        navigationController?.navigationBar.titleTextAttributes =
              [NSAttributedString.Key.foregroundColor: UIColor.systemPurple,
              NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
         
         navigationItem.title = "Your Business Analytics"
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
          guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
              // if keyboard size is not available for some reason, dont do anything
              return
          }
          // move the root view up by the distance of keyboard height
          self.view.frame.origin.y = 0 - keyboardSize.height/2
        self.view.addSubview(backGroundView) //
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(keyboardWillHide(notification:)))
        
        self.backGroundView.addGestureRecognizer(gesture)
    }
      
      
    @objc func keyboardWillHide(notification: NSNotification) {
          // move back the root view origin to zero
        self.view.endEditing(true)
          self.view.frame.origin.y = 0
        self.backGroundView.removeFromSuperview() //
    }
    
    func setupSwipes() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleView))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleView))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
      
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leftView.removeFromSuperview()
        leftViewTitle.removeFromSuperview()
        rightView.removeFromSuperview()
        rightViewLabel.removeFromSuperview()
    }
    
    
    
    //MARK:- Suplimentary functions
    //this escaping completion handler will execute the code in the declaration aboe when the fetching is comeplete
    func setListenerForRevenue(completion: @escaping () -> ()) {
        print("this is being used")
        let db = Firestore.firestore()
        let totals = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!).collection(GlobalVariables.UserIDs.ScanDataString).document(GlobalVariables.UserIDs.TotalScansString)
        totals.addSnapshotListener { (doc, err) in
            if let doc = doc, doc.exists {
                //during the listening phase, these values will keep updating and listening/fetching values from the database if they have been changed.
                let retrievedRevenue = doc.get(GlobalVariables.UserIDs.OwnerRevenueString) as! Double
                self.newRevenue = retrievedRevenue
                let retrievedScans = doc.get(GlobalVariables.UserIDs.CustomerPurchasesString) as! Double
                self.totalScans = retrievedScans
                self.totalRevenueLabel.text = String(describing: "$\(self.newRevenue.rounded(toPlaces: 2))")
                self.averageRevenueLabel.text = String(describing: "$\((self.newRevenue/self.totalScans).rounded(toPlaces: 2))")
                
                
            }
        }
    }
    
    
    
    
    
    
    
    
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
    //MARK:-middle view setup.
    func setupMiddleView() {
        //setup the middle container view
        middleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/1.2, height: self.view.frame.size.height/1.4)
        middleView.center.x = self.view.frame.size.width/2
        middleView.center.y = self.view.center.y
        middleView.backgroundColor = .clear
        self.view.addSubview(middleView)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleView))
        rightSwipe.direction = .right
        self.middleView.addGestureRecognizer(rightSwipe)
        setupTotalScansView(parentView: middleView)
        setupTotalRevenueView(parentView: middleView)
        setupAverageRevenueView(parentView: middleView)
        
        
        //setup the bottom view
        bottomView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - middleView.frame.size.height - 150)
        bottomView.center.x = self.view.center.x
        bottomView.center.y = self.view.frame.size.height - bottomView.frame.size.height/2
        bottomView.backgroundColor = .clear
        //setup the chevron button so that the user can switch to see all his/her customer data.
        setupSwitchButton(view: bottomView)
        self.view.addSubview(bottomView)
        
        
        //setup the input variables for the main view. (average, total, scans, etc.)
        
        
    }
    
 
    //MARK:- left view setup
    func setupSideView() {
    
        
        leftView.frame = self.middleView.frame
        leftView.center.x = -self.view.frame.size.width/2
        leftView.backgroundColor = .black
        leftView.layer.cornerRadius = 30
        leftView.center.y = self.view.frame.size.height/2
      
//        leftViewTitle.frame = CGRect(x: 0, y: 0, width: leftView.frame.size.width, height: 20)
//        leftViewTitle.center.x =  -self.view.frame.size.width/2
//        leftViewTitle.center.y = leftView.center.y - leftView.frame.size.height/2 - 40
//        leftViewTitle.text = "Customers"
//        leftViewTitle.font = UIFont(name: "Poppins", size: 20)
//        leftViewTitle.textAlignment = .center
//        leftViewTitle.textColor = .systemPurple
//        self.view.addSubview(leftViewTitle)
        
        
        
        let chartView = CustomerTable(currentUserEmail: Auth.auth().currentUser?.email!, leftView: leftView, superView: self.view!)
        chartView.populateData()
        
        self.leftView.addSubview(chartView)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleView))
        leftSwipe.direction = .left
        self.leftView.addGestureRecognizer(leftSwipe)
        chartView.addGestureRecognizer(leftSwipe)
        
        self.view.addSubview(leftView)
    }
    
    func setupSwitchButton(view: UIView) {
        let backGroundImage = UIImage(systemName: "chevron.left")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        switchButton.frame = CGRect(x: 0, y: 0, width: 25, height: 35)
        switchButton.center.x = view.frame.size.width/2
        switchButton.center.y = view.frame.size.height/2 - 10
        switchButton.setBackgroundImage(tintedImage, for: .normal)
        switchButton.tintColor = Global_Colors.colors.softBlue
        switchButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        
        
        view.addSubview(switchButton)
    }
    
    //MARK:- right view setup
    
       func setupRightView() {
            
            rightView.frame = self.middleView.frame
            rightView.center.x = self.view.frame.size.width + self.view.frame.size.width/2
            rightView.backgroundColor = .black
            rightView.layer.cornerRadius = 30
            rightView.center.y = self.view.frame.size.height/2
            
    //        rightViewLabel.frame = CGRect(x: 0, y: 0, width: rightView.frame.size.width, height: 20)
    //        rightViewLabel.center.x =  self.view.frame.size.width + self.view.frame.size.width/2
    //        rightViewLabel.center.y = rightView.center.y - rightView.frame.size.height/2 - 40
    //        rightViewLabel.text = "Tickets"
    //        rightViewLabel.font = UIFont(name: "Poppins", size: 20)
    //        rightViewLabel.textAlignment = .center
    //        rightViewLabel.textColor = .systemPurple
    //        self.view.addSubview(rightViewLabel)
            
            
            
            let chartView = ScansTable(rightView: rightView, parentView: self.view, currentUserEmail: Auth.auth().currentUser?.email)
            chartView.populateData()
            self.rightView.addSubview(chartView)
            self.view.addSubview(rightView)
            let gesture = UISwipeGestureRecognizer(target: self, action:  #selector(transitionRightViewtoCenter))
            gesture.direction = .right
            chartView.addGestureRecognizer(gesture)

            

            
            
            
            
        }
    func setupRightViewButton() {
        rightViewButton.translatesAutoresizingMaskIntoConstraints = false
        rightViewButton.frame = CGRect(x: 0, y: 0, width: 25, height: 35)
        self.view.addSubview(rightViewButton)
        self.view.bringSubviewToFront(rightViewButton)
        let backGroundImage = UIImage(systemName: "chevron.right")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        rightViewButton.setBackgroundImage(tintedImage, for: .normal)
        rightViewButton.tintColor = Global_Colors.colors.softBlue
        rightViewButton.addTarget(self, action: #selector(transitionRightViewtoCenter), for: .touchUpInside)


        
        
        //constraints
        rightViewButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.size.height/2).isActive = true
        rightViewButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        rightViewButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        rightViewButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    
    }
    
    @objc func transitionRightViewtoCenter() {
        if self.rightView.center.x == self.view.frame.size.width/2 {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            self.rightView.center.x = self.view.frame.size.width + self.view.frame.size.width/2
//            self.rightViewLabel.center.x = self.view.frame.size.width + self.view.frame.size.width/2
            self.rightViewButton.isHidden = false
            self.navigationItem.title = "Aggregate Data"

                       
                   }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.rightView.center.x = self.view.frame.size.width/2
//                self.rightViewLabel.center.x = self.view.frame.size.width/2
                self.rightViewButton.isHidden = true
                self.navigationItem.title = "Tickets"

                                  
                                  
                              }, completion: nil)
                   }
        }
    
    
    
    
    
    //MARK:- other views and actions
    @objc func toggleView() {
        if toggleValue == true {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                self.middleView.center.x = self.view.frame.size.width * 1.5
                self.switchButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//                self.leftViewTitle.center.x =  self.view.frame.size.width/2
                self.leftView.center.x = self.view.frame.size.width/2
                self.rightViewButton.isHidden = true
                
                self.newLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.toggleView))
                self.newLeftSwipe.direction = .left
                self.view.addGestureRecognizer(self.newLeftSwipe)
                self.navigationItem.title = "Customers"

                self.toggleValue = false
                
                
                
            }, completion: nil)
        } else {
            
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                self.middleView.center.x = self.view.frame.size.width/2
                self.switchButton.transform = CGAffineTransform.identity
                self.leftView.center.x = -self.view.frame.size.width/2
//                self.leftViewTitle.center.x =  -self.view.frame.size.width/2
                self.toggleValue = true
                self.navigationItem.title = "Aggregate Data"
                self.rightViewButton.isHidden = false
                self.view.removeGestureRecognizer(self.newLeftSwipe)
                
            }, completion: nil)
        }
    }
    
    func setupTotalScansView(parentView: UIView) {
        totalScansView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        totalScansView.center.x = parentView.frame.size.width/4
        totalScansView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.9
        totalScansView.backgroundColor = .systemIndigo
        totalScansView.layer.cornerRadius = 30
        
//        setupShadow(view: totalScansView)
        
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
//        setupShadow(view: totalLabel)
        
        
        //setup the animation view
        
        
        setupAnimation(parentView: totalScansView, animationView: animationView3, animationName: GlobalVariables.animationTitles.mainLoader)
       
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
    
    func setupAnimationGraph(parentView: UIView, animationView: AnimationView, animationName: String) {
        animationView.animation = Animation.named(animationName)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(animationView)
        animationView.widthAnchor.constraint(equalToConstant: parentView.frame.size.width/1.5).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: parentView.frame.size.width/1.5).isActive = true
        animationView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 50).isActive = true
        animationView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: 0).isActive = true
        animationView.contentMode = .scaleAspectFit
        
        animationView.layer.cornerRadius = 30
        animationView.backgroundColor = .white
        animationView.play()
        animationView.loopMode = .playOnce
        
        parentView.sendSubviewToBack(animationView)
    }
    
    
    
    func setupTotalRevenueView(parentView: UIView) {
        totalRevenueView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        totalRevenueView.center.x = parentView.frame.size.width - totalRevenueView.frame.size.width/1.5
        totalRevenueView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.2
        
        totalRevenueView.backgroundColor = .systemIndigo
        totalRevenueView.layer.cornerRadius = 30
        
//        setupShadow(view: totalRevenueView)
        
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
//        setupShadow(view: totalLabel)
        
        
        
        
        
        
        setupAnimation(parentView: totalRevenueView, animationView: animationView2, animationName:GlobalVariables.animationTitles.mainLoader)


        parentView.addSubview(totalRevenueView)
        
        
    }
    
    
    func setupAverageRevenueView(parentView: UIView) {
        averageRevenueView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width/2.5, height: self.middleView.frame.size.height/4 - 20)
        averageRevenueView.center.x = parentView.frame.size.width/4
        averageRevenueView.center.y = self.middleView.frame.size.height - self.middleView.frame.size.height/1.2
        
        averageRevenueView.backgroundColor = .systemIndigo
        averageRevenueView.layer.cornerRadius = 30
        
//        setupShadow(view: averageRevenueView)
        
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
//        setupShadow(view: totalLabel)
        
        
        
        
        
        setupAnimation(parentView: averageRevenueView, animationView: animationView1, animationName: GlobalVariables.animationTitles.mainLoader)

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
    /// Rounds the double to decimal places value/Users/sebastianbarry/Downloads/22554-bar-graph-icon/Graph_Bar.json
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}





