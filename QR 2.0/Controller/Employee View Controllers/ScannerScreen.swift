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
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
        
     
        override func viewDidLoad() {
            super.viewDidLoad()
            setupCamera()
        }
     
    //setup the camera function
    func setupCamera() {
        
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
    
    
        func failed() {
            let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            avCaptureSession = nil
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if (avCaptureSession?.isRunning == false) {
                self.navigationController?.isNavigationBarHidden = true
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
            GlobalVariables.ActualIDs.ActualQRData = code
            
            
            
            let db = Firestore.firestore()
            //fetch the document array for the user.
            let document = db.collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email!)!)
                           //we not have a document
                           document.getDocument(source: .cache) { (dataPiece, error) in
                               if let error = error {print(error.localizedDescription)}
                                //this is where the logic happens
                               else {
                                
                                //fetch the employer business email to redirect pointer to from the current employee
                                let employerBusinessEmail = dataPiece?.get("Employer")
                                
                                //fetch the employers business
                                let employerBusinessDocument = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(employerBusinessEmail as! String)
                                
                                //get the name
                                employerBusinessDocument.getDocument(source: .cache) { (otherDataPiece, error) in
                                    if let error = error {print(error.localizedDescription)}
                                    
                                    else {
                                        let employerBusinessName = otherDataPiece?.get(GlobalVariables.UserIDs.BusinessName) as! String
                                        
                                        //check if the user exists
                                        let document2 = db.collection(GlobalVariables.UserIDs.CollectionTitle).document(code)
                                        document2.getDocument { (doc, err) in
                                            if let doc = doc, doc.exists {
                                                
                                                
                                                //increment the point of the user.
                                                GlobalFunctions.incrementPointsForUser(nameofUser: code, nameofBusiness: employerBusinessName)
                                                //implement more logic like if the user has redemption points available.
                                                
                                                
                                        
                                            } else {
                                                print(err?.localizedDescription)
                                            }
                                        }
                                        
                                    }
                                }
                                
                                   }
                              }
                          
                            self.performSegue(withIdentifier: GlobalVariables.SegueIDs.AddPointsScreeSegue, sender: self)
        }
    }
