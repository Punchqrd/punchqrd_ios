//
//  RedeemConfirm.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/6/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class RedeemConfirm : UIViewController {
    
    let animationView = AnimationView()
    
    @IBOutlet weak var RedeemButton: UIButton!
    @IBOutlet weak var ReturnButton: UIButton!
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        self.ReturnButton.isHidden = true
        GlobalFunctions.setButtonRadius(button: self.RedeemButton)
        GlobalFunctions.setButtonRadius(button: self.ReturnButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //MARK:- Actions
    @IBAction func RedeemAction(_ sender: UIButton) {
        self.addLoadingView()
        GlobalFunctions.deleteAllPoints(nameofUser: GlobalVariables.ActualIDs.ActualCustomer, nameofBusiness: GlobalVariables.ActualIDs.CurrentNameofBusiness)
        GlobalFunctions.setRedemptionToTrue(nameofUser: GlobalVariables.ActualIDs.ActualCustomer, nameofBusiness: GlobalVariables.ActualIDs.CurrentNameofBusiness)
        self.removeLoadingView()
        self.RedeemButton.backgroundColor = .green
        self.RedeemButton.setTitle("Confirmed!", for: .normal)
        self.RedeemButton.isEnabled = false
        self.ReturnButton.isHidden = false
    }
    
    
    @IBAction func ReturnAction(_ sender: UIButton) {
        self.backTwo()
    }
    
    
    //MARK:- Supplimentary functions
    func backTwo() {
        self.navigationController?.popToViewController(ofClass: EmployeeHome.self)
    }
    
    
    
    //MARK:- Animation functions
    func addLoadingView() {
        self.setupAnimation()
    }
    
    func setupAnimation() {
        let animationNames : [String] = ["CroissantLoader", "BeerLoader", "PizzaLoader", "CoffeeLoader"]
        let randomNumber = Int.random(in: 0...3)
        self.animationView.animation = Animation.named(animationNames[randomNumber])
        self.animationView.frame.size.height = self.view.frame.height
        self.animationView.frame.size.width = self.view.frame.width
        self.animationView.contentMode = .center
        self.animationView.backgroundColor = .white
        self.animationView.play()
        self.animationView.loopMode = .loop
        self.view.addSubview(self.animationView)
    }
    
    func removeLoadingView() {
        self.animationView.stop()
        self.animationView.removeFromSuperview()
    }
    
    
    
}

//MARK:- Extensions
extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
