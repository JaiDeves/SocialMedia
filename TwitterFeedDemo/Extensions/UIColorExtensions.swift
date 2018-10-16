//
//  UIColorExtensions.swift
//  DemoApp
//
//  Created by Rajul Arora on 10/27/17.
//  Copyright © 2017 Twitter. All rights reserved.
//

import UIKit

extension UIColor {
    class var pubplatPurple: UIColor {
        return UIColor(red: 121.0 / 255.0, green: 75.0 / 255.0, blue: 196.0 / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
