//
//  ScannerScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 5/31/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import Lottie


class ScannerScreen:  UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let animationView = AnimationView()
    var overlayLayer = CALayer()
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
    
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overlayLayer.sublayers = nil
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addLoadingView()
        self.navigationController?.isNavigationBarHidden = true
        if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
        self.overlayLayer.sublayers = nil
    }
    
    //MARK:- Camera Setup
    //setup the camera function
    func setupCamera() {
        
        self.removeLoadingView()
        self.overlayLayer.sublayers = nil
        
        self.avCaptureSession = AVCaptureSession()
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
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
}

//MARK:- Extension to Camera
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
    
    
    //Logic function when the user has found a code
    func found(code: String) {
        //animate the screen when the code is read.
        self.addCheckMarkView()
        
        /// seperate the code into its comoonents (email), and (unique code)
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
                                                    print("function is called")
                                                    //if the user is eligible for redemption, then give the user a redemption point
                                                    self.avCaptureSession.stopRunning()
                                                    self.removeLoadingView()
                                                    GlobalVariables.ActualIDs.ActualCustomer = String(customerEmail)
                                                    GlobalVariables.ActualIDs.CurrentNameofBusiness = employerBusinessName
                                                    //DispatchQueue.main.async {
                                                        self.performSegue(withIdentifier: GlobalVariables.SegueIDs.RedemptionSegue, sender: self)
                                                //}
                                                    

                                                    
                                                }
                                                if totalAccruedPoints < 10 {
                                                    //INCREMENT Points.
                                                    //this is whre the segue happens for the user
                                                    
                                                    self.removeLoadingView()
                                                    self.avCaptureSession.stopRunning()
                                                    GlobalVariables.ActualIDs.ActualCustomer = String(customerEmail) //this is the customers email
                                                    GlobalVariables.ActualIDs.CurrentNameofBusiness = employerBusinessName //this is the name of the business
                                                    GlobalVariables.ActualIDs.CurrentNameofEmployer = (employerBusinessEmail as! String)
                                                    self.performSegue(withIdentifier: GlobalVariables.SegueIDs.toPriceView, sender: self)
                                                }
                                            }
                                            
                                            
                                            else {
                                                self.removeLoadingView()
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                           
                                        }
                                    }
                                }
                                else {
                                    print("1")
                                    self.removeLoadingView()
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } else {
                            print("2")
                            self.removeLoadingView()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
                
            }
        }
        
        
        
        
    }
    
    
    
    //MARK:- Animations
    func setupCheckAnimation() {
        self.animationView.animation = Animation.named("CheckMark")
        self.animationView.frame.size.height = self.view.frame.height
        self.animationView.frame.size.width = self.view.frame.width
        self.animationView.contentMode = .center
        self.animationView.backgroundColor = .white
        self.animationView.play()
        self.animationView.loopMode = .playOnce
        self.view.addSubview(self.animationView)
    }
    
    
    func addCheckMarkView() {
        self.setupCheckAnimation()
    }
    
    
    func addLoadingView() {
        self.setupAnimation()
    }
    
    
    func setupAnimation() {
        
        self.animationView.animation = Animation.named(GlobalVariables.animationTitles.mainLoader)
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



//MARK:- Extensions to UIImage
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












