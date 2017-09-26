//
//  Extentions.swift
//  Ma7al
//
//  Created by Mustafa on 9/17/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit


extension UIView {
    func addConsWithFormat(format:String,views:UIView...) {
        var viewDictionary = [String:UIView]()
        for (ind,view) in views.enumerated() {
            let key = "v\(ind)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
        
    }
}

extension UIView {
    func addShadow(){
        let SHADOW_COLOR:CGFloat = 157.0 / 255.0
        self.layer.cornerRadius = 2.0
        self.layer.shadowColor = UIColor(red:0.22, green:0.28, blue:0.38, alpha:1.0).cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in  }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 1.0
                        self.isUserInteractionEnabled = true
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.0
                        self.isUserInteractionEnabled = false
        }, completion: completion)
    }
}

