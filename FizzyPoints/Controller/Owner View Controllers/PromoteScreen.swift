//
//  PromoteScreen.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 7/29/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import FirebaseAuth
import FirebaseFirestore

class PromoteScreen: UIViewController, UIPopoverPresentationControllerDelegate{

    //variable declarations
    private lazy var rocketAnimation: AnimationView = {
        let view = AnimationView()
        return view
    }()
    let backButton = UIButton()
    let promotionView = UIView()
    let allPromotionsButton = UIButton()
    
    
    
    //view functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerAtributes()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupRocketAnimation(parentView: self.view, animationView: rocketAnimation, animationName: "mailman")
    }
    
    //main setup for viewcontroller
    func setupViewControllerAtributes() {
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        //add a swipe up gesture recognizer to return to the main menu
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(popToMain))
        leftSwipe.direction = .up
        self.view.addGestureRecognizer(leftSwipe)
        
        
        setupToHideKeyboardOnTapOnView()

        //setup layers
        setupBackButton()
        setupPromotionView()
        setupAllPromotionButton()
    }
    
    
    //rocket animation for bottom of the screen
    func setupRocketAnimation(parentView: UIView, animationView: AnimationView, animationName: String) {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animation = Animation.named(animationName)
        animationView.frame = CGRect(x: 0, y: 0, width: parentView.frame.size.width/2, height: parentView.frame.size.width/2)
        parentView.addSubview(animationView)
        parentView.sendSubviewToBack(animationView)
        animationView.widthAnchor.constraint(equalToConstant: parentView.frame.size.width/2).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: parentView.frame.size.width/2).isActive = true
        animationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        animationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        animationView.contentMode = .scaleAspectFit
        animationView.layer.cornerRadius = 30
        animationView.backgroundColor = .white
        animationView.play()
        animationView.loopMode = .autoReverse
    }
    
    
    func setupBackButton() {
        let backGroundImage = UIImage(systemName: "chevron.down")
        let tintedImage = backGroundImage?.withRenderingMode(.alwaysTemplate)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        backButton.setBackgroundImage(tintedImage, for: .normal)
        backButton.tintColor = .systemPurple
        backButton.addTarget(self, action: #selector(popToMain), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
    }
    
    
    //MARK:- Setup the promotionview
    func setupPromotionView() {
        promotionView.translatesAutoresizingMaskIntoConstraints = false
        promotionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/1.1, height: self.view.frame.size.height/3)
        promotionView.backgroundColor = .systemPurple
        promotionView.layer.cornerRadius = 30
        self.view.addSubview(promotionView)
        promotionView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/1.1).isActive = true
        promotionView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/3).isActive = true
        promotionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        promotionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        

        let mailView = MailView(superView: promotionView, parentViewController: self)
        mailView.setupView()
        promotionView.addSubview(mailView)
        


    }
    
    
    func setupAllPromotionButton() {
        allPromotionsButton.translatesAutoresizingMaskIntoConstraints = false
        allPromotionsButton.titleLabel?.font =  UIFont(name: "Poppins", size: 15)
        allPromotionsButton.setTitleColor(Global_Colors.colors.softBlue, for: .normal)
        allPromotionsButton.setTitle("View my promotions", for: .normal)
        allPromotionsButton.backgroundColor = .clear
        allPromotionsButton.addTarget(self, action: #selector(allPromosAction), for: .touchUpInside)
        self.view.addSubview(allPromotionsButton)
        self.view.bringSubviewToFront(allPromotionsButton)
        allPromotionsButton.topAnchor.constraint(equalTo: promotionView.bottomAnchor, constant: 15).isActive = true
        allPromotionsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        allPromotionsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        allPromotionsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- obcj functions
    
    //to next all promotions screen.
    @objc func allPromosAction() {
        let promoteScreen = AllPromotions()
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(promoteScreen, animated: false)
    }
    //return to the main menu
    @objc func popToMain() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    

    
    
}
