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
    @IBOutlet weak var IDLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setup the image as the QR code, with input parameter as user email.
        image.image = generateQR(value: Auth.auth().currentUser?.email!)
        self.IDLabel.text = (Auth.auth().currentUser?.email!)
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
    

