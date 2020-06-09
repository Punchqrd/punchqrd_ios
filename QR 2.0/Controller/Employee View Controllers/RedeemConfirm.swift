//
//  RedeemConfirm.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 6/6/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RedeemConfirm : UIViewController {
    
    
    
    @IBOutlet weak var RedeemButton: UIButton!
    @IBOutlet weak var ReturnButton: UIButton!
    
    
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
    
    
    @IBAction func RedeemAction(_ sender: UIButton) {
        
        GlobalFunctions.deleteAllPoints(nameofUser: GlobalVariables.ActualIDs.ActualCustomer, nameofBusiness: GlobalVariables.ActualIDs.CurrentNameofBusiness)
        
        self.RedeemButton.backgroundColor = .green
        self.RedeemButton.setTitle("Confirmed!", for: .normal)
        self.RedeemButton.isEnabled = false
        self.ReturnButton.isHidden = false
    }
    
    
    @IBAction func ReturnAction(_ sender: UIButton) {
        self.backTwo()
    }
    
    func backTwo() {
        self.navigationController?.popToViewController(ofClass: EmployeeHome.self)
        

    }
    
}

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
