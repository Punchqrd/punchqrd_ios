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


class MailView: UIView, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
       
        print("This is being called")
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
        pushMailButton.setTitleColor(.black, for: .normal)
        pushMailButton.setTitle("Send.", for: .normal)
        pushMailButton.backgroundColor = .clear
        self.addSubview(pushMailButton)
        pushMailButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pushMailButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        pushMailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        pushMailButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.bringSubviewToFront(pushMailButton)
        
        
        //setup textView
        textInputBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        textInputBackGroundView.backgroundColor = superView?.backgroundColor
        textInputBackGroundView.layer.cornerRadius = 30
        textInputBackGroundView.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width/2, height: self.frame.size.width/2)
        self.addSubview(textInputBackGroundView)
        self.sendSubviewToBack(textInputBackGroundView)
        textInputBackGroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        textInputBackGroundView.bottomAnchor.constraint(equalTo: pushMailButton.topAnchor, constant: 0).isActive = true
        textInputBackGroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        textInputBackGroundView.widthAnchor.constraint(equalToConstant: self.frame.size.width/2).isActive = true
        
        
        textInputForMail.translatesAutoresizingMaskIntoConstraints = false
        textInputForMail.textColor = .black
        textInputForMail.font = UIFont(name: "Poppins-Light", size: 14)
        textInputForMail.text = "Type your message here. Short and sweet!"
        textInputForMail.isUserInteractionEnabled = true
        textInputForMail.keyboardType = UIKeyboardType.default
        textInputForMail.returnKeyType = UIReturnKeyType.done
        textInputForMail.textAlignment = .natural
        textInputForMail.delegate = self
        textInputForMail.layer.cornerRadius = 10
        textInputForMail.backgroundColor = superView?.backgroundColor
        self.textInputBackGroundView.addSubview(textInputForMail)
        textInputForMail.topAnchor.constraint(equalTo: textInputBackGroundView.topAnchor, constant: 10).isActive = true
        textInputForMail.bottomAnchor.constraint(equalTo: textInputBackGroundView.bottomAnchor, constant: -10).isActive = true
        textInputForMail.rightAnchor.constraint(equalTo: textInputBackGroundView.rightAnchor, constant: -10).isActive = true
        textInputForMail.leftAnchor.constraint(equalTo: textInputBackGroundView.leftAnchor, constant: 10).isActive = true
        
     
        
        
        imageInputBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        imageInputBackGroundView.backgroundColor = Global_Colors.colors.apricot
        imageInputBackGroundView.layer.cornerRadius = 30
        self.addSubview(imageInputBackGroundView)
        imageInputBackGroundView.leftAnchor.constraint(equalTo: self.textInputBackGroundView.rightAnchor, constant: 50).isActive = true
        imageInputBackGroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        imageInputBackGroundView.bottomAnchor.constraint(equalTo: pushMailButton.topAnchor, constant: -70).isActive = true
        imageInputBackGroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        imageInputBackGroundView.widthAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        
        
       
        //setup max character label
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.text = "\(characterCount)/500"
        characterCountLabel.textAlignment = .center
        characterCountLabel.textColor = .white
        characterCountLabel.font = UIFont(name: "Poppins", size: 14)
        self.superView!.addSubview(characterCountLabel)
        self.superView!.bringSubviewToFront(characterCountLabel)
        characterCountLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        characterCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        characterCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        characterCountLabel.topAnchor.constraint(equalTo: self.pushMailButton.bottomAnchor, constant: 5).isActive = true
        
        
        
        //set the button for uploading a photo and the image holder
        uploadPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoButton.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        uploadPhotoButton.titleLabel?.font =  UIFont(name: "Poppins", size: 13)
        uploadPhotoButton.setTitleColor(.black, for: .normal)
        uploadPhotoButton.setTitle("Upload a Photo.", for: .normal)
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        uploadPhotoButton.layer.cornerRadius = (self.frame.size.width/3.5)/2 
        uploadPhotoButton.backgroundColor = Global_Colors.colors.softYellow
        imageInputBackGroundView.addSubview(uploadPhotoButton)
        uploadPhotoButton.centerXAnchor.constraint(equalTo: imageInputBackGroundView.centerXAnchor).isActive = true
        uploadPhotoButton.centerYAnchor.constraint(equalTo: imageInputBackGroundView.centerYAnchor).isActive = true
        uploadPhotoButton.widthAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        uploadPhotoButton.heightAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        
        
        imageInputForMail.translatesAutoresizingMaskIntoConstraints = false
        imageInputForMail.backgroundColor = .clear
        imageInputForMail.layer.cornerRadius = 30
        imageInputBackGroundView.addSubview(imageInputForMail)
        imageInputForMail.centerXAnchor.constraint(equalTo: imageInputBackGroundView.centerXAnchor).isActive = true
        imageInputForMail.centerYAnchor.constraint(equalTo: imageInputBackGroundView.centerYAnchor).isActive = true
        imageInputForMail.widthAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        imageInputForMail.heightAnchor.constraint(equalToConstant: self.frame.size.width/3.5).isActive = true
        
        
        
    }
    
    
    
    
    
    //view functionality
    @objc func uploadPhoto() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        parentViewController.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageInputForMail.image = image
            imageInputBackGroundView.bringSubviewToFront(imageInputForMail)
            self.uploadPhotoButton.isHidden = true
        }
        
        parentViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    //uitextview delegate function
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            self.characterCount = newText.count
            characterCountLabel.text = "\(self.characterCount)/500"

            return numberOfChars < 500    // 10 Limit Value
    }
    
}



