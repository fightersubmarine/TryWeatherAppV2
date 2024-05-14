//
//  MainScreenViewController.swift
//  TryWeatherAppV2
//
//  Created by Алина on 07.05.2024.
//

import UIKit
import SnapKit
import RxSwift

private extension CGSize {
    static let cellLayoutSize = CGSize(width: 140, height: 140)
    static let imageForButtonSize = CGSize(width: 40, height: 40)
}

private extension CGFloat {
    static let cornerRadius = 16.0
    static let cornerRadiusForTopCell = 10.0
    static let minimumLineSpacing: CGFloat = 12
    static let mainMenuCellLayoutSize: CGFloat = 60
    static let fontSize: CGFloat = 40
    static let delayForTap = 10
}

final class MainScreenViewController: UIViewController {
    
    // MARK: - Properties

    let disposeBag = DisposeBag()
    let viewModel = MainScreenViewModel()
    let icon = IconChange.overcast
    
    //MARK: - Lazy var
    
     lazy var cityNameLabel: UILabel = {
         let label = UILabel.customLabel(text: placeholders.placeholderForLabel)
         label.sizeToFit()
         label.font = UIFont.systemFont(ofSize: CGFloat(CGFloat.fontSize))
         return label
    }()
        
     lazy var tempLabel: UILabel = {
         UILabel.customLabel(text: placeholders.placeholderForLabel)
    }()
    
     lazy var descriptionWeatherLabel: UILabel = {
         UILabel.customLabel(text: placeholders.placeholderForLabel)
    }()
    
     lazy var windSpeedLabel: UILabel = {
         UILabel.customLabel(text: placeholders.placeholderForLabel)
    }()
    
     lazy var locationButton: UIButton = {
         let button = UIButton()
         button.backgroundColor = .clear
         button.layer.cornerRadius = CGFloat.cornerRadius
         let image = UIImage(systemName: "location")?.withRenderingMode(.alwaysTemplate)
         let imageSize = CGSize.imageForButtonSize
         button.setImage(image?.resized(to: imageSize), for: .normal)
    
         return button
    }()
    
    lazy var weatherCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, 
                                          collectionViewLayout: self.weatherCollectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(MainScreenCollectionViewCell.self,
                            forCellWithReuseIdentifier: "CollectionViewCellID")
        collection.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: "DefaultCellID")
        return collection
    }()
    
    private lazy var weatherCollectionLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = CGFloat.minimumLineSpacing
        return layout
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        updateUIOnButtonPress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeRequest()
        updateUI()
    }
    
}

private extension MainScreenViewController {
    
    // MARK: - UI  Configuration

    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(cityNameLabel)
        view.addSubview(tempLabel)
        view.addSubview(descriptionWeatherLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(weatherCollection)
        view.addSubview(locationButton)
    }
    
    func setupLayout() {
        
        cityNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constraint.constant146)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constraint.constant192)
            $0.height.equalTo(Constraint.constant64)
        }
        
        locationButton.snp.makeConstraints {
            $0.leading.equalTo(cityNameLabel.snp.trailing).offset(Constraint.constant2)
            $0.centerY.equalTo(cityNameLabel)
            $0.height.width.equalTo(Constraint.constant64)
        }
                
        tempLabel.snp.makeConstraints{
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(Constraint.constant12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constraint.constant96)
            $0.height.equalTo(Constraint.constant96)
        }
        
        descriptionWeatherLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(Constraint.constant12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constraint.constant192)
            $0.height.equalTo(Constraint.constant64)
        }
        
        windSpeedLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(Constraint.constant12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constraint.constant192)
            $0.height.equalTo(Constraint.constant64)
        }
        
        weatherCollection.snp.makeConstraints {
            $0.top.equalTo(windSpeedLabel.snp.bottom).offset(Constraint.constant48)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constraint.constant146)
        }
        
    }
    
    // MARK: - Update UI functions
    
    func changeRequest() {
        var lastRequest: changeRequest
        let isCitySelectedFromTable = UserDefaults.standard.string(forKey: "selectedCity") != nil
        if isCitySelectedFromTable {
            lastRequest = .cityFromTableView
        } else {
            if CityListManager.shared.loadCity().last != nil {
                lastRequest = .searchCity
            } else {
                lastRequest = .location
            }
        }
        viewModel.fetchWeather(for: lastRequest)
    }
    
    func updateUI() {
        viewModel.weatherObservable
            .subscribe(onNext: { [weak self] weather in
                guard let self = self, let weather = weather else { return }
                self.cityNameLabel.text = weather.city
                self.tempLabel.text = "\(weather.today.temperature)°C"
                self.descriptionWeatherLabel.text = weather.today.description
                self.windSpeedLabel.text = "Wind \(weather.today.formattedWindSpeed) m/s"
            })
            .disposed(by: disposeBag)
    }

    func updateUIOnButtonPress() {
        locationButton.rx.tap
            .throttle(.seconds(CGFloat.delayForTap), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                UIView.transition(with: self?.locationButton ?? UIView(), duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self?.locationButton.backgroundColor = .searchButtonColor
                }, completion: { _ in
                    UIView.transition(with: self?.locationButton ?? UIView(), duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self?.locationButton.backgroundColor = .clear
                    }, completion: nil)
                })
                
                self?.viewModel.fetchWeather(for: .location)
            })
            .disposed(by: disposeBag)
//        updateUI()
    }
    
}

// MARK: - Extension for UICollectionViewDataSource, UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        viewModel.weatherObservableForecast
            .observe(on: MainScheduler.instance) 
            .subscribe(onNext: { 
                forecastArray in
                itemCount = forecastArray.count
                collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellID", for: indexPath) as? MainScreenCollectionViewCell else {
            return UICollectionViewCell()
        }

        let forecastData = viewModel.getForecastData()

        if indexPath.item < forecastData.count {
            let forecast = forecastData[indexPath.item]
            cell.dataCellLabel.text = forecast.formattedDate
            cell.tempCellLabel.text = "\(forecast.temperature) °C"
            if let icon = IconChange(rawValue: forecast.description) {
                cell.imageCellLabel.text = icon.emoji
            } else {
                cell.imageCellLabel.text = "\(forecast.description)"
            }
        }

        return cell
    }
}

// MARK: - Extension for UICollectionViewDelegateFlowLayout

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.cellLayoutSize
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero,
                            left: Constraint.constant24,
                            bottom: .zero,
                            right: Constraint.constant24)
    }
    
}
