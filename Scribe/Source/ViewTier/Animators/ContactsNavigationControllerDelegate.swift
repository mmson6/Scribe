//
//  ContactsNavigationControllerDelegate.swift
//  Scribe
//
//  Created by Mikael Son on 7/21/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactsNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    var shouldAnimate = false
    let animator = ContactGroupsTransitionAnimator()
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = fromVC as? ContactsVC {
            self.shouldAnimate = true
        } else if let _ = toVC as? ContactsVC {
            self.shouldAnimate = true
        }
        
        if shouldAnimate {
            self.shouldAnimate = false
            
            switch operation {
            case .pop:
                self.animator.operationPush = false
            case .push:
                self.animator.operationPush = true
            default:
                self.animator.operationPush = true
            }
            
            return self.animator
        } else {
            return nil
        }
    }
}
