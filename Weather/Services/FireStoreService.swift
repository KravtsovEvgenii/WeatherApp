//
//  FireStoreService.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import Foundation
import FirebaseFirestore
import Firebase
class FireStoreService {
    static let shared = FireStoreService()
    private let dataBaseRef = Firestore.firestore()
    
    func addToUserCities(cityTitle: String, forUser user: AppUser, completion: (([String],Error?)->Void)?) {
        getUserCities(forUser: user) { (result) in
            switch result {
            case .success(var cities):
                cities.append(cityTitle)
                self.dataBaseRef.collection("cities").document(user.id).setData([
                    "cities":cities
                ])
                if let completion = completion {
                    completion(cities,nil)
                }
            case .failure(let err):
                completion!([],err)
            }
        }
    }
    
    func createUserCitiesRef(forUser user: AppUser) {
        self.dataBaseRef.collection("cities").document(user.id).setData([
            "cities":[]
        ])
    }
    
    func getUserCities(forUser user: AppUser, completion: @escaping (Result<[String],Error>)->Void) {
        dataBaseRef.collection("cities").document(user.id).getDocument { (snapshot, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let snapshot = snapshot {
                guard let data = snapshot.data() else {return}
                
                if let array = data["cities"] as? [String] {
                    completion(.success(array))
                }
            }
        }
    }
    func removeCity(cityTitle: String,forUser user: AppUser, completion: @escaping (Result<[String],Error>)->Void) {
        getUserCities(forUser: user) { (result) in
            switch result {
            
            case .success(var finalCities):
                self.safeRemovingCities(cityToRemove: cityTitle, inArray: finalCities, completion: {(cities) in
                    finalCities = cities
                    self.dataBaseRef.collection("cities").document(user.id).setData(["cities":finalCities])
                    completion(.success(finalCities))
                })
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func safeRemovingCities(cityToRemove city: String, inArray cities: [String],completion: @escaping ([String])->Void){
        var tempArray = cities
        for (index,tempCity) in cities.enumerated() {
            if tempCity.lowercased() == city.lowercased() {
                tempArray.remove(at: index)
                safeRemovingCities(cityToRemove: city, inArray: tempArray, completion: { (cities)  in
                    tempArray = cities
                })
                completion(tempArray)
                return
            }
        }
        completion(tempArray)
    }
}


