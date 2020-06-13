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
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var CodeField: UITextField!
    @IBOutlet weak var ConfirmButton: UIButton!
    
    //MARK:- View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CodeField.delegate = self
        GlobalFunctions.setButtonRadius(button: self.ConfirmButton)
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
    }
    
    
    //keyboard delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //button action
    @IBAction func CheckCodeAction(_ sender: UIButton) {
        self.view.resignFirstResponder()
        self.view.endEditing(true)
        if self.CodeField.text!.isEmpty == true {self.ErrorLabel.text = "Enter Code"}
        else{
            self.addLoadingView()
            let codeData = db.collection(GlobalVariables.UserIDs.AccessCodeCollectionTitle).document(self.CodeField.text!)
            codeData.getDocument { (codeDocument, error) in
                if let codeDocument = codeDocument, codeDocument.exists {
                    self.performSegue(withIdentifier: GlobalVariables.SegueIDs.AccessCodeSuccessSegue, sender: self)
                    self.removeLoadingView()
                } else {
                    self.removeLoadingView()
                    self.ErrorLabel.text = "No code exists."
                    
                }
            }
            
        }
        
    }
    
    
    //MARK:- Animations
    func addLoadingView() {
        self.setupAnimation()
    }
    
    
    func setupAnimation() {
        let animationNames : [String] = ["CroissantLoader", "BeerLoader", "PizzaLoader", "CoffeeLoader"]
        let randomNumber = Int.random(in: 0...3)
        self.animationView.animation = Animation.named(animationNames[randomNumber])
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
