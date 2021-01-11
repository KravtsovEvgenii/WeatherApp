//
//  CitiesPresenter.swift
//  Weather
//
//  Created by User on 08.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CitiesPresentationLogic {
  func presentData(response: Cities.Model.Response.ResponseType)
}

class CitiesPresenter: CitiesPresentationLogic {
  weak var viewController: CitiesDisplayLogic?
  
  func presentData(response: Cities.Model.Response.ResponseType) {
    switch response {
    
    case .prepareToDisplay(response: let response, cities: var cities):
        
        let userCurrentCity = response.city.name
        cities.insert(userCurrentCity, at: 0 )
        viewController?.displayData(viewModel: .displayCities(cities: cities))
        
       
    case .prepareUpdatedCities(cities: let cities):
        viewController?.displayData(viewModel: .displayCities(cities: cities))
    case .logout(error: let error):
        viewController?.displayData(viewModel: .logout(error: error))
    }
  }
  
}
