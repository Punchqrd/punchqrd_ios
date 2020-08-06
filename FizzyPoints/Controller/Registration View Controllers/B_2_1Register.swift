//
//  B_2_1Register.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 6/4/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Lottie

class B_2_1Register : UIViewController, UITextFieldDelegate {
    
    let animationView = AnimationView()
    let db = Firestore.firestore()
    
    var ErrorLabel = UILabel()
    var CodeField = UITextField()
    var ConfirmButton = ActionButton(backgroundColor: .black, title: "Confirm", image: nil)
    
    //MARK:- View functions
    override func viewDidLoad() {

        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        self.CodeField.delegate = self
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        setupButtonWithView()
        
        navigationController?.navigationBar.titleTextAttributes =
             [NSAttributedString.Key.foregroundColor: UIColor.black,
              NSAttributedString.Key.font: UIFont(name: Fonts.importFonts.mainTitleFont, size: 25)!]
        navigationItem.title = "So you're a business owner."
    }
    
    
    //keyboard delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupButtonWithView() {
        view.addSubview(ConfirmButton)
        ConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        ConfirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        ConfirmButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        ConfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        ConfirmButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        ConfirmButton.addTarget(self, action: #selector(CheckCodeAction), for: .touchUpInside)
        
        view.addSubview(CodeField)
        CodeField.translatesAutoresizingMaskIntoConstraints = false
        CodeField.widthAnchor.constraint(equalTo: ConfirmButton.widthAnchor).isActive = true
        CodeField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        CodeField.bottomAnchor.constraint(equalTo: ConfirmButton.topAnchor, constant: 10).isActive = true
        CodeField.textColor = .black
        CodeField.borderStyle = .none
        CodeField.placeholder = "Code"
        CodeField.textAlignment = .left
        CodeField.font = UIFont(name: Fonts.importFonts.paragraphFont, size: 20)
        CodeField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        
        
        
    }
    
    
    //button action
     @objc func CheckCodeAction() {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        if self.CodeField.text!.isEmpty == true {let alert = UIAlertController(title: "Enter a code.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (alert: UIAlertAction) in
                return
            }))
            self.present(alert, animated: true, completion: nil)}
        else{
            self.addLoadingView()
            let codeData = db.collection(GlobalVariables.UserIDs.AccessCodeCollectionTitle).document(self.CodeField.text!)
            codeData.getDocument { (codeDocument, error) in
                if let codeDocument = codeDocument, codeDocument.exists {
                    self.performSegue(withIdentifier: GlobalVariables.SegueIDs.AccessCodeSuccessSegue, sender: self)
                    self.removeLoadingView()
                } else {
                    self.removeLoadingView()
                    let alert = UIAlertController(title: "No code exists", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (alert: UIAlertAction) in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
        
    }
    
    
    //MARK:- Animations
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
