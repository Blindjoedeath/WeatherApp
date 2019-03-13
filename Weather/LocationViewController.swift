//
//  ViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 01/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {

    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var permissionNotificationLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var defineLocationButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    
    private var updatingLocation = false
    private var updatingIndicator: UIActivityIndicatorView!
    private var locationError: NSError?
    private var location: CLLocation?
    private var locationManager: CLLocationManager!
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var timer: Timer!
    private var forecastRequestResult: RequestResult<Forecast>!
    private var forecastViewController: ForecastViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.borderStyle = .roundedRect
        setDate()
        addGestureRecognizer()
        
        updateLabels()
    }
    
    func setDate(){
        let date = Date()
        todayLabel.text = "Сегодня " + date.day + ","
        dateLabel.text = date.formatted(by: "d MMMM yyyy")
    }
    
    @IBAction func nextButtonTouch(){
        
        let city = cityTextField.text!
        let weatherRequest = WeatherRequest<Weather>(url: ApiUrl.weatherUrl(for: city))
        let forecastRequest = WeatherRequest<Forecast>(url: ApiUrl.forecastUrl(for: city))
        
        weatherRequest.perform { result in
            
            switch result {
            case .result(let weather):
                self.performSegue(withIdentifier: "ForecastSegue", sender: weather)
            case .noNetwork:
                let alert = getNetworkAlert()
                self.present(alert, animated: true, completion: nil)
            case .noLocation:
                let alert = getLocationAlert()
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        forecastRequest.perform{ result in
            self.forecastViewController?.setForecastRequestResult(result: result)
            self.forecastViewController = nil
            self.forecastRequestResult = result
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ForecastSegue"{
            let navigationController = segue.destination as! UINavigationController
            let forecastViewController = navigationController.topViewController as! ForecastViewController
            forecastViewController.currentWeather = sender as! Weather
            forecastViewController.city = cityTextField.text
            if let result = forecastRequestResult{
                forecastViewController.setForecastRequestResult(result: result)
            } else {
                self.forecastViewController = forecastViewController
            }
        }
    }
}

extension LocationViewController: UITextFieldDelegate{
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setDarkViewState(_ state : Bool){
        darkView.isHidden = !state
        
        var alpha = 0.0
        if (state){
            alpha = 0.4
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[], animations: {
            self.darkView.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(alpha))
        }, completion:nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setDarkViewState(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setDarkViewState(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}


extension LocationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === darkView)
    }
    
    func addGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
}

extension LocationViewController: CLLocationManagerDelegate{
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        locationError = error as NSError
        stopLocationManager()
        updatingIndicator.stopAnimating()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 ||
            newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || newLocation.horizontalAccuracy < location!.horizontalAccuracy {
            locationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= 65 {
                stopLocationManager()
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.locationError = error! as NSError
                        self.placemark = nil
                    }
                    self.updatingIndicator.stopAnimating()
                    self.updateLabels()
                })
            }
        }
    }
    
    @IBAction func getLocation() {
        if locationManager == nil{
            locationManager = CLLocationManager()
            locationManager.delegate = self
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationPermissionsError()
            return
        }
        
        if !updatingLocation{
            startLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        if status == .denied || status == .restricted {
            showLocationPermissionsError()
        } else {
            getLocation()
        }
        updateLabels()
    }
    
    func showLocationPermissionsError() {
        let alert = UIAlertController(title: "Службы геолокации выключены.",
                                      message: "Пожалуйста, включите их в настройках.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentUpdatingLocationIndicator(){
        let frame = CGRect(x: 0, y: 200, width: 320, height: 568)
        updatingIndicator = UIActivityIndicatorView(frame: frame)
        updatingIndicator.style = .whiteLarge
        updatingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(updatingIndicator)
        updatingIndicator.startAnimating()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            location = nil
            placemark = nil
            locationError = nil
            updatingLocation = true
            cityTextField.text = ""
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            presentUpdatingLocationIndicator()
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false){
                _ in self.didTimeOut()
            }
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    func didTimeOut() {
        locationError = NSError(domain: "Время вышло.",
                                    code: 1, userInfo: nil)
        stopLocationManager()
        updatingIndicator.stopAnimating()
        updateLabels()
    }
    
    func updateLabels(){
        if let error = locationError {
            let alert = UIAlertController(title: error.domain,
                                          message: "Что-то пошло не так.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,
                                          handler: nil))
            present(alert, animated: true, completion: nil)
        } else if let placemark = placemark{
            cityTextField.text = placemark.locality
        }
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted ||
            authStatus == .notDetermined{
            permissionNotificationLabel.isHidden = false
        } else {
            permissionNotificationLabel.isHidden = true
        }
    }
}
