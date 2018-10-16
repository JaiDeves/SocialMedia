//
//  UIView Extension.swift
//  GetAFixMD
//
//  Created by Mobileapptelligence India on 04/09/17.
//  Copyright © 2017 Mobileapptelligence India. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /**
     get constraint from view
     Usage:
     
     if let c = button.constraint(withIdentifier: "my-button-width") {
     // do stuff with c
     }
     */
    
    func constraint(_ withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == withIdentifier }.first
    }    
}



extension UIView {
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    func addthreeSidesBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
}


extension UIView {
    func rotateView(by degree:Double = 180,duration: CFTimeInterval = 1.0, image:UIImage?,completionDelegate: AnyObject? = nil) {
        let defaultDegree:Double = 180
        let angle = degree / defaultDegree
        //        print(angle)
        CATransaction.begin()
        if image != nil{
            CATransaction.setCompletionBlock {
                if let button = self as? UIButton{
                    button.setImage(image, for: .normal)
                }
            }
        }
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * angle)
        rotateAnimation.duration = duration
        
        //        if let delegate: AnyObject = completionDelegate {
        //            rotateAnimation.delegate = delegate
        //        }
        self.layer.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
    }
}


extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView{
    var topView:UIView?{
        return self.subviews.last
    }
}


extension UIViewController {
    func addVisualConstraints(format: String, views: [String: AnyObject], options: NSLayoutConstraint.FormatOptions = [], metrics: [String : AnyObject]? = nil) {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
        constraints.forEach { $0.isActive = true }
    }
    
    func visualConstraint(format: String, _ views: [String: AnyObject]) -> NSLayoutConstraint {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: views).first!
    }
}


extension UIView {
    func centerXinSuperview() {
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview!, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
    }
}
