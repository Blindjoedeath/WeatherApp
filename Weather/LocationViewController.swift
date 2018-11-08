//
//  ViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 01/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var defineLocationButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    
    private let weatherRequest = WeatherRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
