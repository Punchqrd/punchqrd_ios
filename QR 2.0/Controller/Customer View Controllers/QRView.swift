//
//  QRView.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/26/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Firebase

class QRView: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let randomNumber = Int.random(in: 0...1000000)
        GlobalFunctions.resetCode(customerEmail: Auth.auth().currentUser?.email!, codeValue: String(randomNumber))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCodeAndView()
    }
    
    func setupCodeAndView() {
        //generate a string of random numbers
        var randomNumberArray : [Int] = []
        for _ in 1...10 {
            let randomNumber = Int.random(in: 0...9)
            randomNumberArray.append(randomNumber)
        }
        var finalValue = ""
        for values in randomNumberArray {
            finalValue.append(String(values))
        }
        GlobalVariables.ActualIDs.userCustomerCode = finalValue
        GlobalFunctions.appendRandomCode(customerEmail: Auth.auth().currentUser?.email!, codeValue: GlobalVariables.ActualIDs.userCustomerCode!)
        let codeValue = "\((Auth.auth().currentUser?.email!)!) \(finalValue)"
        image.image = generateQR(value: codeValue)
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
    

