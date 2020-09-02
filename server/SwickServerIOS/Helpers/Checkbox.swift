//
//  Checkbox.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/14/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class Checkbox: UIButton {
    
    // Row of table view checkbox is located in
    var row: Int?
    
    // Display cook icon
    func displayCook() {
        var checkedImage = resizeImage(UIImage(systemName: "flame.fill") ?? UIImage(), 35, 40)
        checkedImage = checkedImage?.withTintColor(Helper.hexColor(0x073C78))
        self.setImage(checkedImage, for: UIControl.State.normal)
        
    }
    
    // Display send icon
    func displaySend() {
        var uncheckedImage = resizeImage(UIImage(systemName: "arrowshape.turn.up.right.fill") ?? UIImage(), 40, 35)
        uncheckedImage = uncheckedImage?.withTintColor(Helper.hexColor(0x073C78))
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
