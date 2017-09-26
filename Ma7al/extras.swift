//
//  extras.swift
//  Ma7al
//
//  Created by Mustafa on 9/14/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
import UIKit

typealias DownloadComplete = () -> ()


struct Colors {
    let textColor = UIColor(red:0.15, green:0.32, blue:0.54, alpha:1.0)
    let borderColor = UIColor(red:0.15, green:0.32, blue:0.54, alpha:0.7).cgColor
    let tintColor = UIColor(red:0.15, green:0.32, blue:0.54, alpha:1.0)
    let cyanBackgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    let lineViewBackgroundColor = UIColor(red:0.15, green:0.32, blue:0.54, alpha:1.0)
    let loginButtonColor = UIColor(red:0.05, green:0.72, blue:0.80, alpha:1.0)
    let textFiledTextColor = UIColor(red:0.64, green:0.67, blue:0.71, alpha:1.0)
}

let colors = Colors()


struct Fonts {
    
    func massariBluePrintFont(size:CGFloat) -> UIFont {
        let font = UIFont(name: "A Massir Ballpoint", size: size)
        return font!
        
    }
    
    func jennaFont(size:CGFloat) -> UIFont {
        let font = UIFont(name: "Janna LT", size: size)
        return font!
    }
    
}

let fonts = Fonts()
