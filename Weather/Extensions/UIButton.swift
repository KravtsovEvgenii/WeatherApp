//
//  UIButton.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import Foundation
import UIKit
extension UIButton {
    convenience init (withTitle title: String,
                      backgroundColor: UIColor,
                      titleColor: UIColor,
                      font: UIFont? = .avenir20(),
                      isShadow: Bool = false,
                      cornerRadius: CGFloat = 4){
        //
        self.init(type:.system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
            //блик
            self.layer.shadowOpacity = 0.2
        }
        
    }
}
