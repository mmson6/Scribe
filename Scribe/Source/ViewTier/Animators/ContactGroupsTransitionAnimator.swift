//
//  ContactGroupsTransitionAnimator.swift
//  Scribe
//
//  Created by Mikael Son on 7/20/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactGroupsTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var operationPush = false
    var transitionContext: UIViewControllerContextTransitioning!
    let animationDuration = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        operationPush ? self.animatePresentation(with: transitionContext) : self.animateDismissal(with: transitionContext)
    }
    
    private func animatePresentation(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        
        let animateSink = CGAffineTransform(scaleX: 0.90, y: 0.90)
        
        toView.alpha = 0.4
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            fromView.alpha = 0
            fromView.transform = animateSink
            toView.alpha = 1
        }) { (success) in
            fromView.alpha = 1
            transitionContext.completeTransition(success)
        }
    }
    
    private func animateDismissal(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        let animateFloat = CGAffineTransform(scaleX: 1, y: 1)
        
        toView.alpha = 0.4
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            toView.alpha = 1
            toView.transform = animateFloat
            fromView.alpha = 0
        }) { (success) in
            fromView.alpha = 1
            transitionContext.completeTransition(success)
        }
    }
}
