//
//  LocationView.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol LocationViewProtocol: class {
    
    func showAlert(title: String, message: String)
    func setDate(_: String)
    func setDay(_: String)
    func setCity(_: String)
    func setCities(_: [String])
    
    var isNextNavigationEnabled: Bool {get set}
    var isPermissionNotificationEnabled: Bool {get set}
    var isLocalityButtonEnabled: Bool{get set}
    var isDataLoadingIndicatorEnabled: Bool {get set}
}

class LocationViewController: UIViewController{
    
    var presenter: LocationPresenterProtocol!
    var cities = [""]
    var filteredCities = [""]
    var defaultCountInTableView = 5
    var isCitySet = false
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var permissionNotificationLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var defineLocationButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var updatingIndicator: UIActivityIndicatorView!
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.borderStyle = .roundedRect
        addGestureRecognizer()
        presenter.configureView()
        initUpdatingLocationIndicator()
        configureCityTextField()
    }
    
    func configureCityTextField(){
        cityTextField.rx
            .text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .do(onNext: {[weak self] text in
                if let self = self{
                    self.citiesTableView.isHidden = text.isEmpty || self.isCitySet
                    self.isCitySet = false
                }
            })
            .filter{!$0.isEmpty}
            .subscribe(onNext:{[weak self] text in
                if let self = self{
                    self.presenter.cityNameChanged(on: text)
                    
                    let query = text.lowercased().trimmingCharacters(in: .whitespaces)
                    self.filteredCities = self.cities.filter{element in
                        let city = element.lowercased()
                        if city.contains(" "){
                            let words = city.split(separator: " ")
                            return words.reduce(false, {begins, word in
                                return word.hasPrefix(query) || begins
                            })
                        } else {
                            return city.hasPrefix(query)
                        }
                    }.sorted()
                    self.citiesTableView.reloadData()
                }
            })
            .disposed(by: bag)
        
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        cityTextField.clearButtonMode = .whileEditing
    }
    
    func initUpdatingLocationIndicator(){
        let frame = CGRect(x: 0, y: 200, width: 320, height: 568)
        updatingIndicator = UIActivityIndicatorView(frame: frame)
        updatingIndicator.style = .whiteLarge
        updatingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(updatingIndicator)
    }
    
    @IBAction func nextButtonAction(){
        presenter?.nextNavigationRequired()
    }
    
    @IBAction func geolocationButtonAction(){
        presenter?.geolocationRequired()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let closure = sender as! (UIStoryboardSegue) -> ()
        closure(segue)
    }
}

extension LocationViewController: LocationViewProtocol{
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setCity(_ city: String){
        cityTextField.text = city
        self.isCitySet = true
    }
    
    func setDate(_ date: String) {
        dateLabel.text = date
    }
    
    func setDay(_ day: String) {
        todayLabel.text = "Сегодня " + day + ","
    }
    
    func setCities(_ cities: [String]) {
        self.cities = cities
    }
    
    var isNextNavigationEnabled: Bool {
        get {
            return !nextButton.isHidden
        }
        set {
            nextButton.isHidden = !newValue
        }
    }
    
    var isPermissionNotificationEnabled: Bool {
        get {
            return !permissionNotificationLabel.isHidden
        }
        set {
            permissionNotificationLabel.isHidden = !newValue
        }
    }
    
    var isDataLoadingIndicatorEnabled: Bool {
        get {
            return !updatingIndicator.isAnimating
        }
        set {
            UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
            if newValue{
                updatingIndicator.startAnimating()
            } else{
                updatingIndicator.stopAnimating()
            }
        }
    }
    
    var isLocalityButtonEnabled: Bool {
        get {
            return !defineLocationButton.isHidden
        }
        set {
            orLabel.isHidden = !newValue
            defineLocationButton.isHidden = !newValue
        }
    }
}

extension LocationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
    
    func addGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
}

extension LocationViewController: UITextFieldDelegate{
    
    @objc
    func dismissKeyboard() {
        if cityTextField.isEditing{
            view.endEditing(true)
        } else {
            citiesTableView.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}


extension LocationViewController: UITableViewDataSource, UITableViewDelegate{
    
    func resizeTableView(){
        let cellHeight = Int(citiesTableView.rowHeight)
        let rect = citiesTableView.frame
        
        var height = CGFloat(defaultCountInTableView * cellHeight)
        if filteredCities.count < defaultCountInTableView{
            height = CGFloat(cellHeight * filteredCities.count)
        }
        citiesTableView.frame = CGRect(x: rect.origin.x, y: rect.origin.y,
                                        width: rect.width, height: height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resizeTableView()
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell")!
        cell.textLabel?.text = filteredCities[indexPath.row]
        let fontName = cell.textLabel!.font.fontName
        cell.textLabel!.font = UIFont(name: fontName, size: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityTextField.text = filteredCities[indexPath.row]
        tableView.isHidden = true
        presenter.cityNameChanged(on: cityTextField.text!)
        self.isCitySet = true
    }
    
}
