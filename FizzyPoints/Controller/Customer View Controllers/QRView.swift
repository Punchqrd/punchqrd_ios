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
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(UUID().uuidString)
        let randomNumber = UUID().uuidString
        GlobalFunctions.resetCode(customerEmail: Auth.auth().currentUser?.email!, codeValue: String(randomNumber))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCodeAndView()
    }
    
    
    //MARK:- Suplimentary functions
    /// QR code image setup.
    func setupCodeAndView() {
        //generate a string of random numbers
//        var randomNumberArray : [Int] = []
//        for _ in 1...10 {
//            let randomNumber = Int.random(in: 0...9)
//            randomNumberArray.append(randomNumber)
//        }
//        var finalValue = ""
//        for values in randomNumberArray {
//            finalValue.append(String(values))
//        }
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
    
    
    
}


