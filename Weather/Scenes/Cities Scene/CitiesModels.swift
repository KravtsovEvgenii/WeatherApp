//
//  CitiesModels.swift
//  Weather
//
//  Created by User on 08.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum Cities {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getUserCities(user: AppUser)
        case addCityToUser(city:String,user: AppUser)
        case removeCity(city:String, user: AppUser)
        case logout
      }
    }
    struct Response {
      enum ResponseType {
        case prepareToDisplay(response: NetworkResponse,cities: [String])
        case prepareUpdatedCities(cities: [String])
        case logout(error: Error?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayCities(cities: [String])
        case logout(error: Error?)
      }
    }
  }
  
}
