//
//  ToastView.swift
//  Scribe
//
//  Created by Mikael Son on 8/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

extension UIViewController {
    
    internal func showDropDownToast(message : String) {
        self.removePreviousToast()
        
        let toastBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        toastBackgroundView.addSubview(toastLabel)
        self.view.addSubview(toastBackgroundView)
        toastBackgroundView.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        toastBackgroundView.tag = 100
        toastBackgroundView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 0.8)
        
        toastLabel.backgroundColor = .clear
        toastLabel.textColor = UIColor.Scribe.Design2.blue
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0.2))
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        
        let animateFloatUp = CGAffineTransform(translationX: 0, y: -toastBackgroundView.frame.height)
        toastBackgroundView.transform = animateFloatUp
        toastBackgroundView.alpha = 0
        toastLabel.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            toastBackgroundView.transform = CGAffineTransform.identity
            toastBackgroundView.alpha = 0.8
            toastLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 0.3, options: .curveEaseOut, animations: {
                toastBackgroundView.alpha = 0.0
            }, completion: {(isCompleted) in
                toastBackgroundView.removeFromSuperview()
            })
        }
    }
    
    private func removePreviousToast() {
        let previous = self.view.viewWithTag(100)
        previous?.removeFromSuperview()
    }
    
    internal func showPopUpToast(on view: UIView, text: String) {
        let toast = UIView(frame: CGRect(x: view.center.x - (view.frame.width / 6), y: view.center.y - 100, width: view.frame.width / 3, height: view.frame.width / 4))
        toast.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.70)
        toast.layer.cornerRadius = 10
        toast.alpha = 0
        
        let textLabel = UILabel(frame: toast.bounds)
        textLabel.backgroundColor = .clear
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor(white: 1, alpha: 0.95)
        textLabel.textAlignment = .center
        textLabel.text = text
        toast.addSubview(textLabel)
        
        view.addSubview(toast)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            toast.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseInOut, animations: {
                toast.alpha = 0
            }, completion: { (success) in
                toast.removeFromSuperview()
            })
        }
    }
}


//extension UIWindow {
//    
//    internal func showToast(message : String) {
//        self.removePreviousToast()
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        let toastBackgroundView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: self.frame.width, height: 30))
//        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
//        toastBackgroundView.addSubview(toastLabel)
//        self.addSubview(toastBackgroundView)
//        toastBackgroundView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        
//        toastBackgroundView.tag = 100
//        toastBackgroundView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
//        
//        toastLabel.backgroundColor = .clear
//        toastLabel.textColor = UIColor.Scribe.Design2.blue
//        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont.systemFont(ofSize: 15, weight: 0.2)
//        toastLabel.text = message
//        toastLabel.clipsToBounds  =  true
//        toastLabel.lineBreakMode = .byWordWrapping
//        toastLabel.numberOfLines = 0
//        
//        let animateFloatUp = CGAffineTransform(translationX: 0, y: -toastBackgroundView.frame.height - statusBarHeight)
//        toastBackgroundView.transform = animateFloatUp
//        toastBackgroundView.alpha = 0
//        toastLabel.alpha = 0
//        
//        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            toastBackgroundView.transform = CGAffineTransform.identity
//            toastBackgroundView.alpha = 1
//            toastLabel.alpha = 1
//        }) { (_) in
//            UIView.animate(withDuration: 1.0, delay: 0.3, options: .curveEaseOut, animations: {
//                toastBackgroundView.alpha = 0.0
//            }, completion: {(isCompleted) in
//                toastBackgroundView.removeFromSuperview()
//            })
//        }
//    }
//    
//    private func removePreviousToast() {
//        let previous = self.viewWithTag(100)
//        previous?.removeFromSuperview()
//    }
//}
//
