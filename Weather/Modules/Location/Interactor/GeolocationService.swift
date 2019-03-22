//
//  GeolocationService.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeolocationServiceProtocol{
    func accessState(state: Bool)
    func timeOut()
    func endWithError(error: NSError)
    func foundLocation(locality: String)
}

class GeolocationService: NSObject, CLLocationManagerDelegate{
    
    var delegate: GeolocationServiceProtocol?
    
    var access: Bool {
        get{
            return CLLocationManager.locationServicesEnabled()
        }
    }
    
    private var locationError: NSError?
    private var location: CLLocation?
    private var locationManager: CLLocationManager!
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var timer: Timer?
    private var updatingLocation = false
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {    
        
        locationError = error as NSError
        stopLocationManager()
        delegate?.endWithError(error: locationError!)
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
            
            if newLocation.horizontalAccuracy <= 70 {
                stopLocationManager()
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                        self.delegate?.foundLocation(locality: self.placemark!.locality!)
                    } else {
                        self.locationError = error! as NSError
                        self.placemark = nil
                        self.delegate?.endWithError(error: self.locationError!)
                    }
                })
            }
        }
    }
    
    func getLocation() {
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
            delegate?.accessState(state: false)
            stopLocationManager()
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
            delegate?.accessState(state: false)
        } else {
            delegate?.accessState(state: true)
            getLocation()
        }
    }
    
    private func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            updatingLocation = true
            location = nil
            placemark = nil
            locationError = nil
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 3,
                                         repeats: false) { timer in
                self.didTimeOut()
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    private func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
            timer = nil
        }
    }
    
    @objc
    private func didTimeOut() {
        print("time out")
        locationError = NSError(domain: "Время вышло.",
                                code: 1, userInfo: nil)
        stopLocationManager()
        delegate?.timeOut()
    }
}
