//
//  QRView.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/26/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Firebase

class QRView: UIViewController {
    //240
    private lazy var qrImageView: UIImageView = {
        let qrImageView = UIImageView()
        qrImageView.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        qrImageView.center.x = self.view.frame.size.width/2
        qrImageView.center.y = self.view.frame.size.height/2
        return qrImageView
    }()
    
    let backButton = ActionButton(backgroundColor: Global_Colors.colors.apricot, title: "", image: nil)
    
    
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(UUID().uuidString)
        let randomNumber = UUID().uuidString
        GlobalFunctions.resetCode(customerEmail: Auth.auth().currentUser?.email!, codeValue: String(randomNumber))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCodeAndView()
        navigationItem.hidesBackButton = true

    }
    
    
    //MARK:- Suplimentary functions
    /// QR code image setup.
    func setupCodeAndView() {
       
        //setup the back button
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false 
        backButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        backButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        backButton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
        let backGroundImage = UIImage(systemName: "chevron.up")
              let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .white
        backButton.layer.shadowColor = UIColor.gray.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        backButton.layer.shadowRadius = 8
        backButton.layer.shadowOpacity = 0.4
        
        
        //setup the qr code view
        let id = UUID().uuidString
        GlobalVariables.ActualIDs.userCustomerCode = id
        GlobalFunctions.appendRandomCode(customerEmail: Auth.auth().currentUser?.email!, codeValue: GlobalVariables.ActualIDs.userCustomerCode!)
        let codeValue = "\((Auth.auth().currentUser?.email!)!) \(id)"
        qrImageView.image = generateQR(value: codeValue)
        self.view.addSubview(qrImageView)
    }
    
    
    //this function creates a QR code that is visible as a uiimage
    func generateQR(value: String!) -> UIImage? {
        
        let data = value.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 12, y: 12)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
        
    }
    
    
    @objc func backHome() {
//        let homeScreen = CustomerHomeScreen()
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    
    
}


