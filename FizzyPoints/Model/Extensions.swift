//
//  Extensions.swift
//  FizzyPoints
//
//  Created by Sebastian Barry on 8/4/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    //find the index value for the key input element of type T
    func findValueInForKey<T:Equatable> (_ inputArray: [T], key: T?) -> Int {
        var returnValue : Int?
        for (index, key) in inputArray.enumerated() {
            if key == key {
                returnValue = index
                break
            }
        }
        return returnValue! 
    }
    
    //remove an element from an array  given an array of elements of type T
    func popFromArray<T:Equatable> (_ inputArray: [T], key: T) -> [T] {
        var returnArray = inputArray
        for (index, key) in inputArray.enumerated() {
            if key == key {
                returnArray.remove(at: index)
            }
        }
        return returnArray
    }
    
    
    //replace a value in the array and append a new node in its stead.
    func replaceElementIn<T:Equatable> (_ inputArray: [T], oldkey: T, newkey: T) -> [T] {
        var returnArray = inputArray
        for (index, value) in returnArray.enumerated() {
            if oldkey == value {
                returnArray[index] = newkey
                break
            }
        }
        return returnArray
    }
    
    
   
}


//MARK:- Extension UIColor
extension UIColor {
    
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    
    func as4ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 6))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 6))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}




