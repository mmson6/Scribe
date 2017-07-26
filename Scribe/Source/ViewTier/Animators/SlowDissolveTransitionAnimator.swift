//
//  SlowDissolveTransitionAnimator.swift
//  Scribe
//
//  Created by Mikael Son on 7/26/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class SlowDissolveTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    let transitionDuration = 3.0
    var operationPresenting = false
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operationPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operationPresenting = false
        return nil
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        self.transitionContext = transitionContext
        if self.operationPresenting {
            self.animatePresentation(with: transitionContext)
        } else {
            self.animateDismissal(with: transitionContext)
        }
    }
    
    // MARK: Helper Functions
    
    func animatePresentation(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let logoLabel = toView.viewWithTag(11),
            let authenticationView = toView.viewWithTag(12)
//            let toViewController = transitionContext.viewController(forKey: .to) as? LoginVC,
//            let backgroundView = toViewController.backgroundView,
//            let authenticationView = toViewController.authenticationView,
//            let logoLabel = toViewController.logoLabel
        else {
            return
        }
        
        
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
//        containerView.addSubview(backgroundView)
//        containerView.addSubview(authenticationView)
//        containerView.addSubview(logoLabel)
        
//        
//        backgroundView.alpha = 0
//        authenticationView.alpha = 0
//        logoLabel.alpha = 0
//        
        toView.alpha = 0
        logoLabel.alpha = 0
        authenticationView.alpha = 0
        
//        UIView.animate(withDuration: self.transitionDuration, animations: { 
//            toView.alpha = 1
//            fromView.alpha = 0
//        }) { (success) in
//            fromView.alpha = 1
//            test?.alpha = 0
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
        
        UIView.animate(withDuration: 1.0, animations: {
            fromView.alpha = 0
            toView.alpha = 1
            
            UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
                logoLabel.alpha = 1
            })
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseIn, animations: {
                authenticationView.alpha = 1
            })
        }) { (success) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animateDismissal(with transitionContext: UIViewControllerContextTransitioning) {
        
    }
}




