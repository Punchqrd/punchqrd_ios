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
        let theImage = UIImage(named: "greencheck-1")!
        let imageLayer = CALayer()
        let aspect: CGFloat = theImage.size.width / theImage.size.height
        let width = videoSize.width
        let height = width / aspect
        imageLayer.frame = CGRect(
            x: self.view.frame.width/2,
            y: self.view.frame.height/2,
            width: width,
            height: height)
        theImage.withTintColor(UIColor.green, renderingMode: .alwaysTemplate)
        imageLayer.contents = theImage.cgImage
        layer.addSublayer(imageLayer)
        
    }
    
    private func addXImage(to layer: CALayer, videoSize: CGSize) {
        
        self.overlayLayer.frame = CGRect(origin: .zero, size: self.avPreviewLayer.preferredFrameSize())
        self.view.layer.addSublayer(self.overlayLayer)
        let theImage = UIImage(named: "redx")!
        let imageLayer = CALayer()
        let aspect: CGFloat = theImage.size.width / theImage.size.height
        let width = videoSize.width
        let height = width / aspect
        imageLayer.frame = CGRect(
            x: self.view.frame.width/2,
            y: self.view.frame.height/2,
            width: width,
            height: height)
        imageLayer.contents = theImage.cgImage
        layer.addSublayer(imageLayer)
        
    }
    
    private func addredeemImage(to layer: CALayer, videoSize: CGSize) {
        
        self.overlayLayer.frame = CGRect(origin: .zero, size: self.avPreviewLayer.preferredFrameSize())
        self.view.layer.addSublayer(self.overlayLayer)
        let theImage = UIImage(named: "goldheart")!
        let imageLayer = CALayer()
        let aspect: CGFloat = theImage.size.width / theImage.size.height
        let width = videoSize.width
        let height = width / aspect
        imageLayer.frame = CGRect(
            x: self.view.frame.width/2,
            y: self.view.frame.height/2,
            width: width,
            height: height)
        imageLayer.contents = theImage.cgImage
        layer.addSublayer(imageLayer)
        
    }
    
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
        super.viewWillAppear(animated)
        if (avCaptureSession?.isRunning == false) {
            self.navigationController?.navigationBar.alpha = 0.15
            self.navigationController?.navigationBar.barTintColor = .black
            self.navigationItem.hidesBackButton = true
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
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
        print(code)
        let newValue = code.split(separator: " ")
        let customerEmail = newValue[0]
        print(customerEmail)
        let customerCode = newValue[1]
        print(customerCode)
        //create the database reference.
        GlobalVariables.ActualIDs.ActualQRData = code //set the global variable to the code
        let db = Firestore.firestore()
        
        //Direct to the Employee's field values.
        let employeeData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email!)!)
        //Check out the employees attributes.
        employeeData.getDocument { (dataPiece, error) in
            if let error = error {print(error.localizedDescription)}
            else {
                //look up who the employees employer is..assign the email to a variable.
                let employerBusinessEmail = dataPiece?.get(GlobalVariables.UserIDs.EmployerNameString)
                //redirect to the employers field values and database collection.
                let employerBusinessDocument = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(employerBusinessEmail as! String)
                //get the name of the business the employer owns.
                print(employerBusinessEmail!)
                employerBusinessDocument.getDocument { (otherDataPiece, error) in
                    if let error = error {print(error.localizedDescription)}
                    else {
                        //set the name of the business to a variable.
                        
                        let employerBusinessName = otherDataPiece?.get(GlobalVariables.UserIDs.BusinessName) as? String
                        if employerBusinessName != nil {
                            print(employerBusinessName!)
                            
                            GlobalVariables.ActualIDs.EmployerBusinessName = employerBusinessName
                            
                            
                            //now check if the code scanned from the QR code is a legitimate customer.
                            let customerData = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(String(customerEmail))
                            customerData.getDocument { (doc, err) in
                                if let doc = doc, doc.exists {
                                    
                                    //IF THE USER EXISTS: Do this logic.
                                    
                                    let actualCustomerCodeInBase = doc.get(GlobalVariables.UserIDs.UserCodeString) as! String
                                    print(actualCustomerCodeInBase)
                                    if actualCustomerCodeInBase == customerCode {
                                        
                                        print(true)
                                        //check if the user has 10 points
                                        let customerBusinessCollection = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(String(customerEmail)).collection(GlobalVariables.UserIDs.CustomerBusinessCollection).document(employerBusinessName!)
                                        customerBusinessCollection.getDocument { (documentSnap, error) in
                                            if let error = error {print(error.localizedDescription)}
                                            else {
                                                
                                                let totalAccruedPoints = documentSnap?.get(GlobalVariables.UserIDs.PointsString) as! Int
                                                print(totalAccruedPoints)
                                                //if the user has more than 10 points (is eligible for redemption)?
                                                if totalAccruedPoints == 10 {
                                                    //if the user is eligible for redemption, then give the user a redemption point
                                                    
                                                    GlobalFunctions.deleteAllPoints(nameofUser: String(customerEmail), nameofBusiness: employerBusinessName)
                                                    
                                                    self.addredeemImage(to: self.overlayLayer, videoSize: CGSize.init(width: 100, height: 100))
                                                    
                                                } else if totalAccruedPoints < 10 {
                                                    
                                                    
                                                    //INCREMENT Points.
                                                    GlobalFunctions.incrementPointsForUser(nameofUser: String(customerEmail), nameofBusiness: employerBusinessName)
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
                            
                        } else {self.addXImage(to: self.overlayLayer, videoSize: CGSize.init(width: 100, height: 100))}
                        
                        
                        //statement
                        
                    }
                }
                
            }
        }
        
        self.setupCamera()
    }
    
    
    
}















