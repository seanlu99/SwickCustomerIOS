//
//  Checkbox.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/24/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class Checkbox: UIButton {
    
    // Section of table view checkbox is located in
    var section: Int!
    // Row of section of table view checkbox is located in
    var row: Int!
    
    func check() {
        var checkedImage = resizeImage(UIImage(systemName: "checkmark.square")!, 40, 30)
        checkedImage = checkedImage!.withTintColor(Helper.hexColor(0x073C78))
        self.setImage(checkedImage, for: UIControl.State.normal)
        
    }
    
    func uncheck() {
        var uncheckedImage = resizeImage(UIImage(systemName: "square")!, 40, 30)
        uncheckedImage = uncheckedImage!.withTintColor(Helper.hexColor(0x073C78))
        self.setImage(uncheckedImage, for: UIControl.State.normal)
    }
}

// Resize image
func resizeImage(_ image: UIImage, _ width: CGFloat, _ height: CGFloat) -> UIImage? {
     UIGraphicsBeginImageContext(CGSize(width: width, height: height))
     image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
     let newImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     return newImage
 }
