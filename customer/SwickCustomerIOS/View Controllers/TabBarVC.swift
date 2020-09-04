//
//  TabBarVC.swift
//  SwickCustomerIOS
//
//  Created by Andrew Jiang on 9/2/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    // if a restaurant has been scanned
    var scannedRestaurant = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension TabBarVC: UITabBarControllerDelegate {
    // Returns if TabBarVC should unwind to root view of UINavigationController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // if "Cart" tab selected && currently on "Cart" tab && resturant scanned ==> Do not return to scanner
        // NOTE: function may break if tab order/# of tabs is changed, may need to find better way to reference "Cart" tab
        if viewController == (self.viewControllers?[1] ?? nil)
            && viewController == selectedViewController
            && scannedRestaurant {
            // find and unwind to CartVC
            let currNavController = viewController as? UINavigationController
            for controller in currNavController?.viewControllers ?? [] as Array{
                if controller is CartVC{
                    currNavController?.popToViewController(controller, animated: true)
                    break
                }
            }
            return false
        }
        return true
    }
}
