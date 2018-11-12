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
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var defineLocationButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    
    
    private var updatingLocation = false
    private var locationError: NSError?
    private var location: CLLocation?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var timer: Timer?
    
    private let weatherRequest = WeatherRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        cityTextField.borderStyle = .roundedRect
        setDate()
        addGestureRecognizer()
    }
    
    func setDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        dateFormatter.dateFormat = "EEEE"
        todayLabel.text = "Сегодня " + dateFormatter.string(from: date) + ","
        
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateLabel.text = dateFormatter.string(from: date)
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
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        if newLocation.timestamp.timeIntervalSinceNow < -5
            || newLocation.horizontalAccuracy < 0 {
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
                        print("found")
                    } else {
                        self.locationError = error as NSError?
                        self.placemark = nil
                    }
                })
            }
        }
    }
    
    @IBAction func getLocation() {
        var authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if !updatingLocation{
            startLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .notDetermined){
            return
        }
        if (status == .denied || status == .restricted) {
            showLocationServicesDeniedAlert()
        } else {
            getLocation()
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Службы геолокации выключены",
                                      message:
            "Пожалуйста, включите службы геолокации в настройках.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            location = nil
            placemark = nil
            locationError = nil
            updatingLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            timer = Timer.scheduledTimer(timeInterval: 20, target: self,
                                         selector: #selector(didTimeOut),
                                         userInfo: nil, repeats: false)
        }
        else{
            print("Disabled")
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    @objc
    func didTimeOut() {
        if location == nil {
            stopLocationManager()
            locationError = NSError(domain: "Time out error",
                                        code: 1, userInfo: nil)
        }
    }
}
