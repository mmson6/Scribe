//
//  PullDownTransitionAnimator.swift
//  Scribe
//
//  Created by Mikael Son on 7/21/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class PullDownTransitionAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private let transitionDuration = 0.7
    private var transitionStarted = false
    var operationPresenting = false
    var transitionContext: UIViewControllerContextTransitioning!
    private var gestureRecognizer: UIPanGestureRecognizer!
    var parentVC: String?
    var sourceViewController: ContactDetailVC! {
        didSet {
            self.sourceViewController.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handlePan(pan:)))
//            self.gestureRecognizer = UIPanGestureRecognizer()
//            self.gestureRecognizer.addTarget(self, action: #selector(self.handlePan(pan:)))
//            self.sourceViewController.view.addGestureRecognizer(self.gestureRecognizer)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        if self.operationPresenting {
            self.animatePresentation(with: transitionContext)
        } else {
            self.animateDismissal(with: transitionContext)
        }
    }
    
    func animatePresentation(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else {
                return
        }
        
        
        let containerView = transitionContext.containerView
        let darkenView = UIView(frame: containerView.frame)
        containerView.addSubview(fromView)
        containerView.addSubview(darkenView)
        containerView.addSubview(toView)
        
        
        let animateDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        
        let animateSink = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        darkenView.backgroundColor = UIColor.black
        darkenView.alpha = 0.4
        toView.transform = animateDown
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            fromView.transform = animateSink
            toView.transform = CGAffineTransform.identity
            darkenView.alpha = 1
            
            
        }) { (success) in
            if !transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(success)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
    
    func animateDismissal(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? ContactDetailVC,
            let fromView = fromVC.tableView,
            let toView = transitionContext.view(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let animateDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
//        let animateSink = CGAffineTransform(translationX: 0, y: 25).scaledBy(x: 0.95, y: 0.95)
//        let animateFloat = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        
        toView.alpha = 0.5
//        toView.transform = animateSink
//        fromView.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            fromView.transform = animateDown
//            toView.transform = animateFloat
            toView.alpha = 1
        }) { (success) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            fromView.backgroundColor = .black
        }
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
        return self
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print(transitionCompleted)
    }
    
    func handlePan(pan: UIPanGestureRecognizer) {
        if let interactingView = pan.view {
            
            let translation = pan.translation(in: interactingView)
            let d = translation.y / interactingView.bounds.height * 0.4
            
            guard let interactingView = pan.view else { return }
            
            if !self.transitionStarted {
                switch interactingView {
                case self.sourceViewController.tableView:
                    if self.sourceViewController.tableView.contentOffset.y > 0 {
                        return
                    }
                default:
                    break
                    
                }
            }
            
            switch pan.state {
            case .began:
                if pan.velocity(in: interactingView).y > 0 {
                    guard let identifier = self.parentVC else { return }
                    self.sourceViewController.performSegue(withIdentifier: identifier, sender: nil)
                    self.transitionStarted = true
                }
//                print(pan.velocity(in: pan.view))
//                print("checking d: \(d)")
//                print("check translation: \(translation)")
            case .changed:
//                print(d/4)
                print("check translation: \(d)")
                if self.transitionStarted {
                    if (d/4) < 0 {
                        self.cancel()
                    } else {
                        self.update(-d/4)
                    }
                    
                }
            case .ended:
                print("ended")
                if pan.velocity(in: interactingView).y > 0 {
                    self.finish()
                } else {
                    self.cancel()
                }
                self.transitionStarted = false
                break
            default:
                self.finish()
                self.transitionStarted = false
                break
            }
        }
    }
}
