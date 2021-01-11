//
//  WeatherSceneViewController.swift
//  Weather
//
//  Created by User on 07.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol WeatherSceneDisplayLogic: class {
    func displayData(viewModel: WeatherScene.Model.ViewModel.ViewModelData)
}
var items: [WeatherInfo] = []
class WeatherSceneViewController: UIViewController, WeatherSceneDisplayLogic {
    
    //MARK: Properties
    var interactor: WeatherSceneBusinessLogic?
    var router: (NSObjectProtocol & WeatherSceneRoutingLogic)?
    var tableView = UITableView()
    var cityTitleLabel = UILabel()
    var currentUser: AppUser!
    var currentCity: String!
    // MARK: Object lifecycle
    init(currentUser: AppUser, city: String?) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
        self.currentCity = city
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = WeatherSceneInteractor()
        let presenter             = WeatherScenePresenter()
        let router                = WeatherSceneRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.makeRequest(request: .getNewWeatherData(city: currentCity))
        configureVC()
    }
    
    func displayData(viewModel: WeatherScene.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .presentData(model: let presentable):
            items = presentable.weatherInfo
            DispatchQueue.main.async {
                self.cityTitleLabel.text = presentable.cityTitle + "   " + presentable.countryTitle
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureVC() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        view.addSubview(cityTitleLabel)
        view.addSubview(tableView)
        cityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        cityTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        cityTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        cityTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        cityTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        tableView.topAnchor.constraint(equalTo: cityTitleLabel.bottomAnchor, constant: 4).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
}
//MARK: Table View Setup

extension WeatherSceneViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseID) as! WeatherCell
        cell.setupCell(fromItem: items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
