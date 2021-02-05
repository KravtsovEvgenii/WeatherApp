//
//  CitiesViewController.swift
//  Weather
//
//  Created by User on 08.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import FirebaseAuth
protocol CitiesDisplayLogic: class {
    func displayData(viewModel: Cities.Model.ViewModel.ViewModelData)
}

class CitiesViewController: UIViewController, CitiesDisplayLogic {
    var currentUser: AppUser!
    var interactor: CitiesBusinessLogic?
    var router: (NSObjectProtocol & CitiesRoutingLogic)?
    var tableView = UITableView()
    var addCityButton = UIButton(type: .system)
    var logOutButton = UIButton(type: .system)
    weak var delegate: ControllerTransitionDelegate?
    
    var cities:[String] = []
    // MARK: Object lifecycle
    
    init(withUser appUser: AppUser) {
        super.init(nibName: nil, bundle: nil)
        setup()
        currentUser = appUser
        interactor?.makeRequest(request: .getUserCities(user: appUser))
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = CitiesInteractor()
        let presenter             = CitiesPresenter()
        let router                = CitiesRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func displayData(viewModel: Cities.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayCities(cities: let cities):
            if let currentCity = cities.first {
                currentUser.currentCity = currentCity
            }
            self.cities = cities
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .logout(error: let error):
            guard error == nil else {
                showAlert(withTitle: "Error", withMessage: error!.localizedDescription)
                return
            }
            let alertController = UIAlertController (title: "Are you sure?", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                self.delegate?.goToAuthViewController()
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
}

extension CitiesViewController {
    private func setupUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        view.addSubview(addCityButton)
        view.addSubview(tableView)
        view.addSubview(logOutButton)
      
        addCityButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addCityButton.setTitle("+", for: .normal)
        addCityButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        addCityButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addCityButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addCityButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addCityButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        addCityButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        addCityButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        tableView.topAnchor.constraint(equalTo: addCityButton.bottomAnchor, constant: 4).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logOutButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        logOutButton.addTarget(self, action: #selector(logOutButtonAction), for: .touchUpInside)
        
    }
   
    
    @objc private func logOutButtonAction() {
        interactor?.makeRequest(request: .logout)
    }
    
    @objc private func addButtonAction() {
        let alertController = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alertController.addTextField { (tf) in
            tf.placeholder = "City title"
        }
        let okAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let cityTitle = alertController.textFields?[0].text {
                guard cityTitle != "" else {return}
                
                self.interactor?.makeRequest(request: .addCityToUser(city: cityTitle, user: self.currentUser))
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension CitiesViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseID) as! WeatherCell
        cell.setupCell(fromCity: cities[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Some Difference")
        router?.presentWeatherVC(withCity: cities[indexPath.row], user: self.currentUser)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, _) in
            
            self.interactor?.makeRequest(request: .removeCity(city: self.cities[indexPath.row], user: self.currentUser))
            
        }
     
        deleteAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        deleteAction.image = UIImage(named: "delete")
        
        let conf = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return conf
    }
    
    
}
