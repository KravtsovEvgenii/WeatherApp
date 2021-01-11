//
//  ControllerTransitionDelegate.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import Foundation
protocol ControllerTransitionDelegate: class {
    func goToCitiesVC(withUser appUser: AppUser)
    func goToAuthViewController()
}
