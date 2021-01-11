//
//  AuthViewController.swift
//  Weather
//
//  Created by User on 08.01.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPasswordStackView = UIStackView(arrangeSubviews: [confirmPasswordLabel,confirmPasswordTextField], axis: .vertical, spacing: 0)
        setupConstraints()
        view.backgroundColor = .systemBackground
        enterButton.addTarget(self, action: #selector(enterButtonAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        view.addGestureRecognizer(gesture)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Properties
    weak var delegatee: ControllerTransitionDelegate?
    //Labels
    let welcomeLabel = UILabel(withText: "Welcome!", font: .avenir26())
    let emailLabel = UILabel(withText: "Email")
    let passwordLabel = UILabel(withText: "Password")
    let confirmPasswordLabel = UILabel(withText: "Confirm Password")
    //Buttons
    let enterButton = UIButton(withTitle: "Enter", backgroundColor: .black, titleColor: .white)
    //Text Fielsd
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    let registerButton  = UIButton(withTitle: "Register", backgroundColor: .systemBlue, titleColor: .white)
    var confirmPasswordStackView: UIStackView!
    var registerFlag = false
    
    //MARK: Methods
    @objc private func gestureAction() {
        UIView.animate(withDuration: 0.4) {
            self.view.frame.origin.y = 0
        }
        view.endEditing(true)
    
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.frame.origin.y = -keyboardHeight / 2
            }
        }
    }
    @objc private func enterButtonAction() {
        AuthService.shared.login(withEmail: emailTextField.text, withPassword: passwordTextField.text) { (result) in
            switch result {
            case .success(let user):
                let appUser = AppUser(email: user.email!, id: user.uid, name: user.displayName, currentCity: nil)
                self.delegatee?.goToCitiesVC(withUser: appUser)
            case .failure(let error):
                self.showAlert(withTitle: "Error", withMessage: error.localizedDescription)
            }
        }
    }
    
    @objc private func registerButtonAction() {
        if registerFlag {
            AuthService.shared.registerUser(withEmail: emailTextField.text, withPassword: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
                switch result {
                case .success(let user):
                    let appUser = AppUser(email: user.email!, id: user.uid, name: user.displayName, currentCity: nil)
                    FireStoreService.shared.createUserCitiesRef(forUser: appUser)
                    self.delegatee?.goToCitiesVC(withUser: appUser)
                case .failure(let error):
                    self.showAlert(withTitle: "Error", withMessage: error.localizedDescription)
                }
            }
        }
        UIView.animate(withDuration: 1) {
            self.confirmPasswordStackView.isHidden = false
        }
        registerFlag = true
    }
}
//MARK: Setup Constraints
extension AuthViewController {
    private func setupConstraints() {
        //Email
        let emailStackView = UIStackView(arrangeSubviews: [emailLabel,emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangeSubviews: [passwordLabel,passwordTextField], axis: .vertical, spacing: 0)
        
        confirmPasswordStackView.isHidden = true
        enterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let generalStackView = UIStackView(arrangeSubviews: [emailStackView,passwordStackView,confirmPasswordStackView,registerButton,enterButton], axis: .vertical, spacing: 40)
        
        
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(generalStackView)
        view.addSubview(welcomeLabel)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 100).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //General Stack View
        generalStackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 140).isActive = true
        generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40).isActive = true
        generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40).isActive = true
    }
}
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.4) {
            self.view.frame.origin.y = 0
        }
        
        textField.resignFirstResponder()
        return true
    }
}

