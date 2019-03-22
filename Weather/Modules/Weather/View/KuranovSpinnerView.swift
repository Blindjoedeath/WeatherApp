//
//  RjumanSpinnerView.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 16.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit

class KuranovSpinnerView: UIView {
    
    private var signalToStop : Bool = false
    private var stopCompletion : (() -> Void)?
    
    @IBOutlet weak var kuanovView : UIImageView!
    
    var isAnimating: Bool = false
    
    private func animate(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear,
                       animations: {[weak self] in
                        self?.kuanovView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear,
                           animations: {[weak self] in
                                self?.kuanovView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                            }, completion: {[weak self] _ in
                                if let signalToStop = self?.signalToStop,
                                    !signalToStop{

                                    self?.animate()
                                } else {
                                    self?.stopAnimation()
                                }
                            })
        })
    }
    
    private func stopAnimation(){
        if let completion = stopCompletion{
            isAnimating = false
            completion()
        }
    }
    
    func startAnimation(){
        if !isAnimating {
            signalToStop = false
            isAnimating = true
            animate()
        }
    }
    
    func stopAnimation(completion : @escaping () -> Void){
        stopCompletion = completion
        signalToStop = true
    }
    
    deinit {
        print("deinited kuranov spiner view")
    }
}
