//
//  PullDownTransitionAnimator.swift
//  Scribe
//
//  Created by Mikael Son on 7/21/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class PullDownTransitionAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private let transitionDuration = 1.0
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
        darkenView.alpha = 0
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
            let fromViewSnapshot = fromVC.tableView.snapshotView(afterScreenUpdates: false),
            let toView = transitionContext.view(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .white
//        containerView.addSubview(backgroundView)
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
//        containerView.addSubview(fromViewSnapshot)
        print("animte animte")
        
        let animateDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        let animateSink = CGAffineTransform(translationX: 0, y: 25).scaledBy(x: 0.95, y: 0.95)
        let animateFloat = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        
        toView.transform = animateSink
        fromView.backgroundColor = .clear
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            fromView.transform = animateDown
            toView.transform = animateFloat
        }) { (success) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromView.backgroundColor = .white
//            fromViewSnapshot.removeFromSuperview()
        }
        
//        
//        let darkenView = UIView(frame: containerView.frame)
////        let darkBackgroundView = UIView(frame: containerView.frame)
////        darkBackgroundView.backgroundColor = .black
////        containerView.addSubview(darkBackgroundView)
//        containerView.addSubview(toView)
//        containerView.addSubview(darkenView)
//        containerView.addSubview(fromViewSnapshot)
//        
//        let animateDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
//        let animateFloat = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
//        
//        darkenView.backgroundColor = .black
//        darkenView.alpha = 1
//        toView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
//            fromViewSnapshot.transform = animateDown
//            darkenView.alpha = 0
//            toView.transform = animateFloat
//        }) { (success) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
////            if !transitionContext.transitionWasCancelled {
//////                transitionContext.finishInteractiveTransition()
////                transitionContext.completeTransition(success)
////                
////            } else {
//////                transitionContext.cancelInteractiveTransition()
////                transitionContext.completeTransition(false)
////                
////            }
//            
//        }
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
            
            switch interactingView {
            case self.sourceViewController.tableView:
                if self.sourceViewController.tableView.contentOffset.y > 0 {
                    return
                }
            default:
                break
                
            }
            
            print("checking d: \(d)")
            print("check translation: \(translation)")
            
            switch pan.state {
            case .began:
                break
            case .changed:
                print("changed")
                if self.sourceViewController.tableView.contentOffset.y < 0 {
                    guard let identifier = self.parentVC else { return }
                    print(identifier)
                    self.sourceViewController.performSegue(withIdentifier: identifier, sender: nil)
                    self.transitionStarted = true
                }
            
                if self.transitionStarted {
                    self.update(d)
                }
            case .ended:
                print("ended")
                if pan.velocity(in: interactingView).y > 0 {
                    self.finish()
                } else {
                    self.cancel()
                }
                break
            default:
                self.finish()
                break
            }
        }
    }
}
