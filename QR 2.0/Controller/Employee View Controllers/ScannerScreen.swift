//
//  ScannerScreen.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/31/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore


class ScannerScreen:  UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    var overlayLayer = CALayer()
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overlayLayer.sublayers = nil
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        setupCamera()

        
    }
    
    //setup the camera function
    func setupCamera() {
        
        self.overlayLayer.sublayers = nil
        
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                
                self.avCaptureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
                
            } else {
                self.failed()
                return
            }
            
            
            //layering the camera onto the screen with certain bounds
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.avPreviewLayer)
            self.avCaptureSession.startRunning()
            
            
            
            
            
            
        }
    }
    
    private func addCheckMarkImage(to layer: CALayer, videoSize: CGSize) {
        
        self.overlayLayer.frame = CGRect(origin: .zero, size: self.avPreviewLayer.preferredFrameSize())
        self.view.layer.addSublayer(self.overlayLayer)
        let screenSize : CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.size.width
        let screenHeight = screenSize.size.height
        let greenView = UIImage(color: .green, size: CGSize(width: screenWidth, height: screenHeight))
        
        
        let imageLayer = CALayer()
        let width = screenWidth
        let height = screenHeight
        imageLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height)
        greenView!.withTintColor(UIColor.green, renderingMode: .alwaysTemplate)
        imageLayer.contents = greenView?.cgImage
        layer.addSublayer(imageLayer)
        
        
        
    }
    
    private func addXImage(to layer: CALayer, videoSize: CGSize) {
        
        
        self.overlayLayer.frame = CGRect(origin: .zero, size: self.avPreviewLayer.preferredFrameSize())
        self.view.layer.addSublayer(self.overlayLayer)
        let screenSize : CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.size.width
        let screenHeight = screenSize.size.height
        let greenView = UIImage(color: .red, size: CGSize(width: screenWidth, height: screenHeight))
        
        
        let imageLayer = CALayer()
        let width = screenWidth
        let height = screenHeight
        imageLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height)
        greenView!.withTintColor(UIColor.green, renderingMode: .alwaysTemplate)
        imageLayer.contents = greenView?.cgImage
        layer.addSublayer(imageLayer)
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    /*
    private func addredeemImage(to layer: CALayer, videoSize: CGSize, inputcolor : UIColor) {
        
        self.overlayLayer.sublayers = nil
        self.overlayLayer.frame = CGRect(origin: .zero, size: self.avPreviewLayer.preferredFrameSize())
        self.view.layer.addSublayer(self.overlayLayer)
        let screenSize : CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.size.width
        let screenHeight = screenSize.size.height
        let greenView = UIImage(color: inputcolor, size: CGSize(width: screenWidth, height: screenHeight))
        
        
        let imageLayer = CALayer()
        let width = screenWidth
        let height = screenHeight
        imageLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height)
        greenView!.withTintColor(UIColor.green, renderingMode: .alwaysTemplate)
        imageLayer.contents = greenView?.cgImage
        layer.addSublayer(imageLayer)
        
    }
    */
    
    @IBAction func LogoutAction(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //send the user back to the homescreen
            
            self.navigationController?.popToRootViewController(animated: true)
            print("Logged out the user")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.hidesBackButton = true
        if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /*
     @IBAction func RedeemAction(_ sender: UIButton) {
     GlobalFunctions.deleteAllPoints(nameofUser: GlobalVariables.ActualIDs.ActualQRData, nameofBusiness: GlobalVariables.ActualIDs.EmployerBusinessName)
     GlobalFunctions.setRedemptionToFalse(nameofUser: GlobalVariables.ActualIDs.ActualQRData, nameofBusiness: GlobalVariables.ActualIDs.EmployerBusinessName)
     setupCamera()
     }
     */
    
}

extension ScannerScreen : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    
    func found(code: String) {
        let newValue = code.split(separator: " ")
        let customerEmail = newValue[0]
        let customerCode = newValue[1]
        //create the database reference.
        GlobalVariables.ActualIDs.ActualQRData = code //set the global variable to the code
        
        
        //Direct to the Employee's field values.
        let db = Firestore.firestore()
        let employeeData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email!)!)
        //Check out the employees attributes.
        employeeData.getDocument { (dataPiece, error) in
            if let dataPiece = dataPiece, dataPiece.exists {
                //look up who the employees employer is..assign the email to a variable.
                let employerBusinessEmail = dataPiece.get(GlobalVariables.UserIDs.EmployerNameString)
                //redirect to the employers field values and database collection.
                let employerBusinessDocument = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(employerBusinessEmail as! String)
                //get the name of the business the employer owns.
                employerBusinessDocument.getDocument { (otherDataPiece, error) in
                    if let otherDataPiece = otherDataPiece, otherDataPiece.exists {
                        //set the name of the business to a variable.
                        
                        let employerBusinessName = otherDataPiece.get(GlobalVariables.UserIDs.BusinessName) as? String
                        if employerBusinessName != nil {
                            
                            GlobalVariables.ActualIDs.EmployerBusinessName = employerBusinessName
                            
                            
                            //now check if the code scanned from the QR code is a legitimate customer.
                            let customerData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(String(customerEmail))
                            customerData.getDocument { (doc, err) in
                            
                                if let doc = doc, doc.exists {
                                    
                                    //IF THE USER EXISTS: Do this logic.
                                    
                                    let actualCustomerCodeInBase = doc.get(GlobalVariables.UserIDs.UserCodeString) as! String
                                    if actualCustomerCodeInBase == customerCode {
                                        
                                        //If the code matches : Final logic
                                        GlobalFunctions.incrementScanCountAndSetData(currentEmployee: Auth.auth().currentUser?.email!, currentEmployerEmail: (employerBusinessEmail as! String), userBeingScanned: String(customerEmail))
                                        
                                        
                                        //check if the user has enough points
                                        let customerBusinessCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(String(customerEmail)).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(employerBusinessName!)
                                        customerBusinessCollection.getDocument { (documentSnap, error) in
                                            if let documentSnap = documentSnap, documentSnap.exists {
                               
                                                let totalAccruedPoints = documentSnap.get(GlobalVariables.UserIDs.PointsString) as! Int
                                                //if the user has more than 10 points (is eligible for redemption)?
                                                if totalAccruedPoints >= 10 {
                                                    //if the user is eligible for redemption, then give the user a redemption point
                                                    GlobalVariables.ActualIDs.ActualCustomer = String(customerEmail)
                                                    GlobalVariables.ActualIDs.CurrentNameofBusiness = employerBusinessName
                                                   
                                                    self.performSegue(withIdentifier: GlobalVariables.SegueIDs.RedemptionSegue, sender: self)
                                                 
                                                } else if totalAccruedPoints < 10 {
                                                    //INCREMENT Points.
                                                    GlobalFunctions.incrementPointsForUser(nameofUser: String(customerEmail), nameofBusiness: employerBusinessName, totalPoints: totalAccruedPoints)
                                                    self.addCheckMarkImage(to: self.overlayLayer, videoSize: CGSize.init(width: 100, height: 100))
                                                }
                                           
                                        }
                                            
                                            
                                        }
                                        
                                    }
                                }
                                    
                                else {
                                    //if the user does not exist, or has subsxribed to zumos, then reset the camera view
                                    
                                    self.addXImage(to: self.overlayLayer, videoSize: CGSize.init(width: 100, height: 100))
                                }
                            }
                            
                        } else {self.addXImage(to: self.overlayLayer, videoSize: CGSize.init(width: 100, height: 100))
                        }
                        
                       
                    }
                    
                }
                
            }
        }
        
        self.setupCamera()
    }
    
    
    
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}














