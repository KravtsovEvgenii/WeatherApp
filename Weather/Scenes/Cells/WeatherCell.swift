//
//  WeatherCell.swift
//  Weather
//
//  Created by User on 07.01.2021.
//

import UIKit

class WeatherCell: UITableViewCell {
    //MARK: Properties
    let webImageView = WebImageView()
    let cardView = UIView()
    let temperatureLabel = UILabel()
    let feelsLikeTempLabel = UILabel()
    let dateLabel = UILabel()
    let pressureLabel = UILabel()
    let cloudsLabel = UILabel()
    let cityTitleLabel = UILabel()
    static let reuseID = "WeatherCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SetupCell from info
     func setupCell(fromItem item: WeatherInfo) {
        cardViewSetup()
        setupCellUI()
        webImageView.setImage(fromString: item.iconImageString)
        temperatureLabel.text = String(format: "%.1f", item.temperature)
        feelsLikeTempLabel.text = "Feels like: " + String(format: "%.1f", item.feelsLikeTemp)
        cloudsLabel.text = "Clouds: \(item.clouds)"
        pressureLabel.text = "Pressure: \(item.pressure)"
        dateLabel.text = item.stringDate
   
     }
    //MARK: SetupCell with city title
    func setupCell(fromCity city: String) {
       cardViewSetup()
        cardView.addSubview(cityTitleLabel)
        cityTitleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        cityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cityTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        cityTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        cityTitleLabel.text = city
    }


    //MARK: Setup Cell UI
    private func setupCellUI() {
        cardView.addSubview(webImageView)
        webImageView.translatesAutoresizingMaskIntoConstraints = false
        //webImageView
        webImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        webImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8).isActive = true
        webImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        webImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //Temperature label
        cardView.addSubview(temperatureLabel)
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 54)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        //feels like label
        cardView.addSubview(feelsLikeTempLabel)
        feelsLikeTempLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTempLabel.font = UIFont.systemFont(ofSize: 24)
        feelsLikeTempLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4).isActive = true
        feelsLikeTempLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        //Date label
        cardView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 32)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 16).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: webImageView.leadingAnchor, constant: -16).isActive = true
        //pressure label
        cardView.addSubview(pressureLabel)
        pressureLabel.translatesAutoresizingMaskIntoConstraints = false
        pressureLabel.font = UIFont.systemFont(ofSize: 20)
        pressureLabel.topAnchor.constraint(equalTo: feelsLikeTempLabel.bottomAnchor, constant: 8).isActive = true
        pressureLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        //cloud label
        cardView.addSubview(cloudsLabel)
        cloudsLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudsLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudsLabel.font = UIFont.systemFont(ofSize: 20)
        cloudsLabel.topAnchor.constraint(equalTo: feelsLikeTempLabel.bottomAnchor, constant: 8).isActive = true
        cloudsLabel.leadingAnchor.constraint(equalTo: pressureLabel.trailingAnchor, constant: 16).isActive = true
        cloudsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
    }
    private func cardViewSetup() {
        self.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.frame = CGRect(x: 0, y: 0, width: self.frame.width - 16, height: self.frame.height - 16)
        self.backgroundColor = .clear
        cardView.backgroundColor = #colorLiteral(red: 0.6989362836, green: 0.7702071071, blue: 0.9547712207, alpha: 1)
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowOpacity = 3
        cardView.backgroundColor = #colorLiteral(red: 0.6989362836, green: 0.7702071071, blue: 0.9547712207, alpha: 1)
        cardView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    
}
