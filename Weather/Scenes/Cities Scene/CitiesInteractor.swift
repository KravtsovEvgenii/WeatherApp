//
//  CitiesInteractor.swift
//  Weather
//
//  Created by User on 08.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CitiesBusinessLogic {
  func makeRequest(request: Cities.Model.Request.RequestType)
}

class CitiesInteractor: CitiesBusinessLogic {

  var presenter: CitiesPresentationLogic?
  var service: CitiesService?
  
  func makeRequest(request: Cities.Model.Request.RequestType) {
    if service == nil {
      service = CitiesService()
    }
    switch request {
    
    case .getUserCities(let user):
        let string = API.getStringURL(forCity: nil)
        DataFetcher.shared.getWeather(fromStringURL: string) { (response) in
            if let response = response {
                FireStoreService.shared.getUserCities(forUser: user) { (result) in
                    switch result {
                    case .success(let cities):
                        self.presenter?.presentData(response: .prepareToDisplay(response: response, cities: cities))
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }
        }
    case .addCityToUser(city: let city, user: let user):
        let string = API.getStringURL(forCity: city)
        DataFetcher.shared.getWeather(fromStringURL: string) { (response) in
            if let cityTitle = response?.city.name {
                FireStoreService.shared.addToUserCities(cityTitle: cityTitle, forUser: user, completion: {(cities,error) in
                    guard error == nil else {return}
                    var finalCities = cities
                    if let userCity = user.currentCity {
                        finalCities.insert(userCity, at: 0)
                    }
                    self.presenter?.presentData(response: .prepareUpdatedCities(cities: finalCities))
                })
            }
        }
    case .removeCity(city: let city, user: let user):
        FireStoreService.shared.removeCity(cityTitle: city, forUser: user) { (result) in
            switch result {
            case .success(var cities):
                if let userCity = user.currentCity {
                    cities.insert(userCity, at: 0)
                }
                self.presenter?.presentData(response: .prepareUpdatedCities(cities: cities))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    case .logout:
        AuthService.shared.logOut { (err) in
            presenter?.presentData(response: .logout(error: err))
        }
    }
  }
    
}
