//
//  AuthService.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import Foundation
import FirebaseAuth

class AuthService{
    
    static let shared = AuthService()
     private let auth = Auth.auth()
    
    func registerUser(withEmail email: String?, withPassword password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else{
            completion(.failure(AuthError.notFilled))
            return
        }
        guard password! == confirmPassword! else{
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    func login(withEmail email: String?, withPassword password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = email ,let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
        
    }

    func logOut(completion: (Bool,Error?)-> Void) {
        do{
            try Auth.auth().signOut()
            completion(true,nil)
        }catch {
            print(error.localizedDescription)
            completion(false,error)
        }
    }
}
