//
//  UIStackView.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import Foundation
import UIKit

extension UIStackView {
    
    convenience init(arrangeSubviews: [UIView],axis:NSLayoutConstraint.Axis , spacing: CGFloat) {
        self.init(arrangedSubviews: arrangeSubviews)
        self.axis = axis
        self.spacing = spacing
    }
    
}
