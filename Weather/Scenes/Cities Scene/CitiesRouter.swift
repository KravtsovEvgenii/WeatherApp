//
//  CitiesRouter.swift
//  Weather
//
//  Created by User on 08.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CitiesRoutingLogic {
    func presentWeatherVC(withCity city: String, user: AppUser)
}

class CitiesRouter: NSObject, CitiesRoutingLogic {
    func presentWeatherVC(withCity city: String, user: AppUser) {
        let vc = WeatherSceneViewController(currentUser: user, city: city)
        viewController?.present(vc, animated: true, completion: nil)
    }

  weak var viewController: CitiesViewController?
  
  // MARK: Routing
  
}
