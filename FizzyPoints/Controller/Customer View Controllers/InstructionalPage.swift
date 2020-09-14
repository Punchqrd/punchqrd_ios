//
//  InstructionalPage.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 9/4/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit


protocol InstructionalPageProtocol {
    func didViewInstructions()
}


class InstructionalPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
 
    
    let imageHolder : [String] = ["intro1", "intro2", "intro3", "intro4", "intro5", "intro6"]
    var mainImage = UIImageView()
    var mainLabel = UILabel()
    var backButton = ActionButton(backgroundColor: Global_Colors.colors.apricot, title: "Ready", image: nil)
    var delegate : InstructionalPageProtocol?

    let mainCollection:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Global_Colors.colors.mainQRButtonColor
        setupCollectionView()
        showView()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        backButton.isHidden = true
    }
    
    func showView() {
        self.view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        mainLabel.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        mainLabel.text = "hey, before you begin."
        mainLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        mainLabel.textColor = .white
        mainLabel.numberOfLines = 0
        
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        backButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 40).isActive = true
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        
        
    }
    
    @objc func back() {
        let navigationController = self.navigationController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        self.delegate?.didViewInstructions()
        navigationController?.popViewController(animated: false)
        
        
    }
    
    func setupCollectionView() {
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        mainCollection.setCollectionViewLayout(layout, animated: true)
        mainCollection.delegate = self
        mainCollection.dataSource = self
        self.view.addSubview(mainCollection)
        mainCollection.translatesAutoresizingMaskIntoConstraints = false
        mainCollection.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        mainCollection.heightAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        mainCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        mainCollection.backgroundColor = .white
        mainCollection.register(OnBoardingCell.self, forCellWithReuseIdentifier: "onboardingid")
        mainCollection.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageHolder.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollection.dequeueReusableCell(withReuseIdentifier: "onboardingid", for: indexPath) as! OnBoardingCell
        cell.imageView.image = UIImage(named: self.imageHolder[indexPath.row])

        if indexPath.row == 5 {
            self.backButton.isHidden = false
            self.view.bringSubviewToFront(backButton)

        } else {
            self.backButton.isHidden = true
            self.view.sendSubviewToBack(backButton)
        }
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mainCollection.frame.size.width, height: self.mainCollection.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
}
