//
//  UIViewController.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import UIKit
extension UIViewController {
    func showAlert(withTitle title: String, withMessage message: String, completion: @escaping ()->() = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
        completion()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
