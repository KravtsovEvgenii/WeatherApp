//
//  UILabel + Ext.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(withText text: String,font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
