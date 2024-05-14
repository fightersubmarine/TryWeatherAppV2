//
//  SettingsScreenViewController.swift
//  TryWeatherAppV2
//
//  Created by Алина on 07.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

private extension CGFloat {
    static let cornerRadiusForButton = 4
}


final class CityListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let cityViewModel = CityListViewModel()
    weak var viewModel: MainScreenViewModel?
    let disposeBag = DisposeBag()
    var cityLists: [String] = []
    
    //MARK: - Lazy var
    
    private lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholders.searchBarPlaceholder
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.searchButtonColor
        button.setImage(UIImage(systemName: "magnifyingglass"),for: .normal)
        button.layer.cornerRadius = CGFloat(CGFloat.cornerRadiusForButton)
        return button
    }()
    
    private lazy var cityTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .gray
        tableView.backgroundColor = .clear
        tableView.register(CityListScreenTableViewCell.self,
                           forCellReuseIdentifier: CityListScreenTableViewCell.id)
        tableView.allowsSelectionDuringEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        return tableView
    }()

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        updateViewOnButtonPress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCities()
    }
    
}

private extension CityListViewController {
    
    // MARK: - UI  Configuration
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        view.addSubview(cityTableView)
    }
    
    func setupLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constraint.constant8)
            $0.trailing.equalToSuperview().inset(Constraint.constant48)
            $0.leading.equalToSuperview().inset(Constraint.constant20)
            $0.height.equalTo(Constraint.constant44)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constraint.constant8)
            $0.leading.equalTo(searchBar.snp.trailing).offset(Constraint.constant2)
            $0.trailing.equalToSuperview().inset(Constraint.constant8)
            $0.height.equalTo(Constraint.constant44)
        }
        
        cityTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(Constraint.constant24)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constraint.constant146)
        }
    }
    
    // MARK: - Update UI functions
    
    func updateViewOnButtonPress() {
        searchButton.rx.tap
            .subscribe(onNext: { 
                [weak self] in
                guard let cityName = self?.searchBar.text, !cityName.isEmpty else { return }
                                
                if !(self?.cityViewModel.cityExists(cityName) ?? false) {
                     self?.cityViewModel.saveCity(cityName)
                     self?.loadCities()
                } else {
                    self?.backToMainScreen()
                }
                self?.searchBar.resignFirstResponder()
                self?.backToMainScreen()
                self?.viewModel?.selectionSubject.onNext(.searchCity)
            })
            .disposed(by: disposeBag)
    }
    
    func loadCities() {
        cityLists = cityViewModel.getAllCities()
        cityTableView.reloadData()
    }
    
    func backToMainScreen() {
        if let tabBarVC = self.tabBarController as? MainTabBarController {
            tabBarVC.selectedIndex = 0
        }
    }
        
}

// MARK: - Extension for UITableView

extension CityListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListScreenTableViewCell.id, for: indexPath) as! CityListScreenTableViewCell
        
        let cityName = cityLists[indexPath.row]
        cell.cellCityLabel.text = cityName                
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityNameToDelete = cityLists[indexPath.row]
            cityViewModel.deleteCity(cityNameToDelete)
            cityLists = cityViewModel.getAllCities()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cityLists[indexPath.row]
        UserDefaults.standard.set(selectedCity, forKey: "selectedCity")
        self.viewModel?.selectionSubject.onNext(.cityFromTableView)
        backToMainScreen()
        }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCity = cityLists.remove(at: sourceIndexPath.row)
        cityLists.insert(movedCity, at: destinationIndexPath.row)
    }
    
}
