//
//  LocationView.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

protocol LocationViewProtocol: class {
    
    func showAlert(title: String, message: String)
    func setCurrentDate(date: String)
    func setToday(day: String)
    func setCity(city: String)
    
    var isNextNavigationEnabled: Bool {get set}
    var isPermissionNotificationEnabled: Bool {get set}
    var isDataLoadingIndicatorEnabled: Bool {get set}
}

class LocationViewController: UIViewController{
    
    var presenter: LocationPresenterProtocol!
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var permissionNotificationLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var defineLocationButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    private var updatingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.borderStyle = .roundedRect
        addGestureRecognizer()
        presenter.configureView()
        initUpdatingLocationIndicator()
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
    
    func setCity(city: String){
        cityTextField.text = city
    }
    
    func setCurrentDate(date: String) {
        dateLabel.text = date
    }
    
    func setToday(day: String) {
        todayLabel.text = "Сегодня " + day + ","
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
        presenter.cityNameChanged(on: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
