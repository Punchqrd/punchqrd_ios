//
//  MailView.swift
//  
//
//  Created by Sebastian Barry on 7/30/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Lottie


class MailView: UIView, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    var parentViewController: UIViewController
    var superView: UIView?
    let textInputForMail = UITextView()
    let textInputBackGroundView = UIView()
    let imageInputBackGroundView = UIView()
    let imageInputForMail = UIImageView()
    let pushMailButton = UIButton()
    let uploadPhotoButton = UIButton()
    //set a limit of 200 characters for each textfield.
    var characterCount = 0
    let characterCountLabel = UILabel()
    
    private lazy var animationView1: AnimationView = {
           let view = AnimationView()
           return view
    }()
    
    //initializer
    init(superView: UIView, parentViewController: UIViewController) {
        self.superView = superView
        self.parentViewController = parentViewController

    
        super.init(frame: superView.frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
   
    //basic view setup
    func setupView() {
       
        //setup the main view
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.superView!.addSubview(self)
        self.widthAnchor.constraint(equalToConstant: self.superView!.frame.size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.superView!.frame.size.height).isActive = true
        self.rightAnchor.constraint(equalTo: self.superView!.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.superView!.topAnchor).isActive = true
        
        //setup the push button
        pushMailButton.translatesAutoresizingMaskIntoConstraints = false
        pushMailButton.titleLabel?.font =  UIFont(name: "Poppins", size: 20)
        pushMailButton.setTitleColor(.white, for: .normal)
        pushMailButton.setTitle("Post.", for: .normal)
        pushMailButton.backgroundColor = .clear
        pushMailButton.addTarget(self, action: #selector(sendPromotion), for: .touchUpInside)
        self.addSubview(pushMailButton)
        pushMailButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pushMailButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        pushMailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        pushMailButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.sendSubviewToBack(pushMailButton)
        
        
        //setup textView
        textInputBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        textInputBackGroundView.backgroundColor = .white
        textInputBackGroundView.layer.cornerRadius = 30
        textInputBackGroundView.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width/2, height: self.frame.size.width/2)
        self.addSubview(textInputBackGroundView)
        self.sendSubviewToBack(textInputBackGroundView)
        textInputBackGroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        textInputBackGroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        textInputBackGroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        textInputBackGroundView.widthAnchor.constraint(equalToConstant: self.frame.size.width/2).isActive = true
        
        
        textInputForMail.translatesAutoresizingMaskIntoConstraints = false
        textInputForMail.textColor = .lightGray
        textInputForMail.font = UIFont(name: "Poppins-Light", size: 14)
        textInputForMail.text = "Type your message here. Short and sweet!"
        textInputForMail.isUserInteractionEnabled = true
        textInputForMail.keyboardType = UIKeyboardType.default
        textInputForMail.returnKeyType = UIReturnKeyType.done
        textInputForMail.textAlignment = .natural
        textInputForMail.delegate = self
        textInputForMail.layer.cornerRadius = 10
        textInputForMail.backgroundColor = .white
        self.textInputBackGroundView.addSubview(textInputForMail)
        textInputForMail.topAnchor.constraint(equalTo: textInputBackGroundView.topAnchor, constant: 10).isActive = true
        textInputForMail.bottomAnchor.constraint(equalTo: textInputBackGroundView.bottomAnchor, constant: -10).isActive = true
        textInputForMail.rightAnchor.constraint(equalTo: textInputBackGroundView.rightAnchor, constant: -10).isActive = true
        textInputForMail.leftAnchor.constraint(equalTo: textInputBackGroundView.leftAnchor, constant: 10).isActive = true
        
     
        
     
        
       
        //setup max character label
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.text = "\(characterCount)/500"
        characterCountLabel.textAlignment = .right
        characterCountLabel.textColor = .lightGray
        characterCountLabel.font = UIFont(name: "Poppins", size: 14)
        textInputBackGroundView.addSubview(characterCountLabel)
        textInputBackGroundView.bringSubviewToFront(characterCountLabel)
        characterCountLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        characterCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        characterCountLabel.rightAnchor.constraint(equalTo: textInputBackGroundView.rightAnchor, constant: -20).isActive = true
        characterCountLabel.bottomAnchor.constraint(equalTo: textInputBackGroundView.bottomAnchor, constant: -20).isActive = true
        
        
        
        //set the button for uploading a photo and the image holder
        
        
        imageInputBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        imageInputBackGroundView.backgroundColor = Global_Colors.colors.apricot
        imageInputBackGroundView.layer.cornerRadius = 30
        self.addSubview(imageInputBackGroundView)
        self.bringSubviewToFront(imageInputBackGroundView)
        imageInputBackGroundView.leftAnchor.constraint(equalTo: self.textInputBackGroundView.rightAnchor, constant: 20).isActive = true
        imageInputBackGroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        imageInputBackGroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageInputBackGroundView.widthAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        
        
        imageInputForMail.translatesAutoresizingMaskIntoConstraints = false
        imageInputForMail.backgroundColor = .clear
        imageInputForMail.layer.cornerRadius = (self.frame.size.width/3.5)/2
        imageInputBackGroundView.addSubview(imageInputForMail)
        imageInputForMail.centerXAnchor.constraint(equalTo: imageInputBackGroundView.centerXAnchor).isActive = true
        imageInputForMail.centerYAnchor.constraint(equalTo: imageInputBackGroundView.centerYAnchor).isActive = true
        imageInputForMail.widthAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        imageInputForMail.heightAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
             
        uploadPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoButton.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        uploadPhotoButton.titleLabel?.font =  UIFont(name: "Poppins", size: 13)
        uploadPhotoButton.setTitleColor(.white, for: .normal)
        uploadPhotoButton.setTitle("Add a Photo.", for: .normal)
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        uploadPhotoButton.layer.cornerRadius = (self.frame.size.width/3.5)/2
        uploadPhotoButton.backgroundColor = Global_Colors.colors.softBlue
        uploadPhotoButton.isEnabled = true
        self.addSubview(uploadPhotoButton)
        self.bringSubviewToFront(uploadPhotoButton)
        uploadPhotoButton.centerXAnchor.constraint(equalTo: imageInputBackGroundView.centerXAnchor).isActive = true
        uploadPhotoButton.centerYAnchor.constraint(equalTo: imageInputBackGroundView.centerYAnchor).isActive = true
        uploadPhotoButton.widthAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        uploadPhotoButton.heightAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        
      
        
        
        
    }
    
    
    
    
    
    //view functionality
    @objc func uploadPhoto() {
        
        print("Is pressing")
        let actionSheet = UIAlertController(title: "Photo Source", message: "How would you like to select your photo?", preferredStyle: .actionSheet)
       
        self.parentViewController.popoverPresentationController?.sourceView = self.parentViewController.view
        self.parentViewController.popoverPresentationController?.sourceRect = CGRect(x: self.parentViewController.view.bounds.midX, y: self.parentViewController.view.bounds.midY, width: 0, height: 0)
        
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
             let image = UIImagePickerController()
             image.delegate = self
             image.sourceType = .camera
             image.allowsEditing = true
             self.parentViewController.present(image, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
             let image = UIImagePickerController()
             image.delegate = self
             image.sourceType = .photoLibrary
             image.allowsEditing = true
             self.parentViewController.present(image, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            return
        }))
        
        
        let popOver = actionSheet.popoverPresentationController
        popOver?.sourceView = self.uploadPhotoButton as UIView
        popOver?.sourceRect = (self.uploadPhotoButton as UIView).bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        self.parentViewController.present(actionSheet, animated: true, completion: nil)

        
    }
    
    func handleUpload() {
        
        //send the message logic
        self.pushMailButton.setTitle("Posting..", for: .normal)

        self.pushMailButton.isEnabled = false
                       
                       
                       //retrieve the current business owner's business address
                       let db = Firestore.firestore().collection(GlobalVariables.UserIDs.CollectionTitle).document((Auth.auth().currentUser?.email)!)
                       db.getDocument { (doc, error) in
                                  if let doc = doc, doc.exists {
                                   //find the business address
                                   let businessAddress = doc.get(GlobalVariables.UserIDs.UserZipCode) as! String
                           
                                   //this is where the photo is uploaded to firebase, then when it is done uploading retrieve the metadata code value and set that as the photo id.
                                   ///the photo id will be passed down as a value to the photo id of the photo in the firestore database for each message
                                   
                                   //upload code goes here
                                   let randomID = UUID.init().uuidString
                                   let uploadRef = Storage.storage().reference(withPath: "\(businessAddress)/\(randomID).jpg")
                                   guard let imageData = self.imageInputForMail.image?.jpegData(compressionQuality: 0.80) else { return }
                                   let uploadMetaData = StorageMetadata.init()
                                   uploadMetaData.contentType = "image/jpg"
                                   uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, err) in
                                    
                                       if let error = error {
                                        
                                        let errorAlert = UIAlertController(title: "Hmm", message: "\(error.localizedDescription)", preferredStyle: .alert)
                                           errorAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action: UIAlertAction) in
                                             self.pushMailButton.setTitle("Post.", for: .normal)

                                              //call this function recursively
                                              self.handleUpload()
                                               
                
                                               return
                                           }))
                                        
                                        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                                            self.pushMailButton.setTitle("Post.", for: .normal)

                                            return
                                        }))
                                        
                                        
                                           
                                       } else {
                                           print("All set!")
                                       }
                                   }
                                   
                                   
                                   ///
                                   //now reroute to the main collection and finish uploading everything to the database
                                   let currentDateTime = Date()
                                   let formatter = DateFormatter()
                                   formatter.timeStyle = .medium
                                   formatter.dateStyle = .long
                                   formatter.string(from: currentDateTime)
                                   let date = formatter.string(from: currentDateTime)
                                   let seconddb = Firestore.firestore().collection(GlobalVariables.UserIDs.existingBusinesses).document(businessAddress).collection(GlobalVariables.UserIDs.MessageCollectionTitle).document(date)
                                   seconddb.getDocument { (doc, error) in
                                       if let doc = doc, doc.exists {
                                           return
                                       } else {
                                           
                                          
                                           seconddb.setData([GlobalVariables.UserIDs.Message : self.textInputForMail.text!, GlobalVariables.UserIDs.BinaryID : randomID])
                                           
                                        
                                        self.pushMailButton.setTitle("Posted!", for: .normal)

                                           //this is done at the end refresh the view or animate the view.
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
                                            self.popToMain()
                                            return
                                        }
                                           
                                           
                                            
                                       }
                                   }
                                   
                                   
                                   
                                  }
                       
                       }
                       
                       
                       
                       
                       
                       
                       
    }
    
    
    
    //main submit button function
    @objc func sendPromotion() {
        //guard statement to check if there is anythin
        guard let _ = self.textInputForMail.text else {
            print("Nothing in here")
            return
        }
        
        guard let _ = self.imageInputForMail.image else {
            return
        }
        
        if self.textInputForMail.text == "Type your message here. Short and sweet!" {
            return
        } else {
            let alert = UIAlertController(title: "Ready to Send?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (alert: UIAlertAction) in
               
                self.handleUpload()
                
               
                    
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                return
            }))
            
            
            self.parentViewController.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    //function to call from the completion of the upload state.
     func popToMain() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.parentViewController.navigationController?.view.layer.add(transition, forKey: nil)
        self.parentViewController.navigationController?.popViewController(animated: false)
       }
    
    
    //image pickercontroller delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageInputForMail.image = image
            imageInputForMail.layer.cornerRadius = (self.frame.size.width/3.5)/2
            imageInputForMail.clipsToBounds = true
//            imageInputBackGroundView.bringSubviewToFront(imageInputForMail)
            self.uploadPhotoButton.backgroundColor = .clear
            
        }
        
        parentViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    //uitextview delegate function(s)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            self.characterCount = newText.count
            characterCountLabel.text = "\(self.characterCount)/500"
            return numberOfChars < 500    // 10 Limit Value
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textInputForMail.text == "Type your message here. Short and sweet!" {
            textInputForMail.text = ""
            textInputForMail.textColor = .black
            textInputForMail.font = UIFont(name: "Poppins-Light", size: 14)
        }
    }
    
    
    
}



