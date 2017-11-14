//
//  PullDownTransitionAnimator.swift
//  Scribe
//
//  Created by Mikael Son on 7/21/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class PullDownTransitionAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var tempTranslation: CGPoint!
    private let transitionDuration = 0.3
    public var preparedToTrack = false
    public var transitionStarted = false
    public var scrolledToTop = false
    var operationPresenting = false
    var transitionContext: UIViewControllerContextTransitioning!
    private var gestureRecognizer: UIPanGestureRecognizer!
    var parentVC: String?
    var sourceViewController: ContactDetailVC! {
        didSet {
            self.sourceViewController.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handlePan(pan:)))
//            self.gestureRecognizer = UIPanGestureRecognizer()
//            self.gestureRecognizer.addTarget(self, action: #selector(self.handlePan(pan:)))
//            
//            let gestureView = UIView(frame: CGRect(x: 0, y: 0, width: self.sourceViewController.view.frame.width, height: self.sourceViewController.view.frame.height))
//            gestureView.addGestureRecognizer(self.gestureRecognizer)
//            self.sourceViewController.tableView.insertSubview(gestureView, belowSubview: self.sourceViewController.tableView)
////            self.sourceViewController.view.addGestureRecognizer(self.gestureRecognizer)
        }
    }
    
    // MARK: Transition Delegate Functions
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operationPresenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operationPresenting = true
        return nil
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
    
    // MARK: Helper Functions
    
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
            let toView = transitionContext.view(forKey: .to),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        /*
        let containerView = transitionContext.containerView
        // toVC is the Main View Controller
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        // fromVC is the Modal VC.
        // Hide it for now, since we're going to use snapshots instead.
        fromVC.view.isHidden = true
        
        // Create the snapshot.
        if let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) {
            // Don't forget to add it
            containerView.insertSubview(snapshot, aboveSubview: toVC.view)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                snapshot.center.y += UIScreen.main.bounds.height
                //            toView.transform = animateFloat
                toView.alpha = 1
            }) { (success) in
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
//            
//            UIView.animate(
//                withDuration: transitionDuration(using: transitionContext),
//                animations: {
//                    // Shift the snapshot down by one screen length
//                    snapshot.center.y += UIScreen.main.bounds.height
//            },
//                completion: { _ in
//                    // Cleanup.
//                    // Undo the hidden state. User won't see this because transition is already over.
//                    fromVC.view.isHidden = false
//                    // It's already off-screen, but get rid of the snapshot anyway.
//                    snapshot.removeFromSuperview()
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            }
//            )
        }
        */
 
        
        
        
        
        var containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let animateDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
//        let animateSink = CGAffineTransform(translationX: 0, y: 25).scaledBy(x: 0.95, y: 0.95)
//        let animateFloat = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        
        toView.alpha = 0
//        toView.transform = animateSink
//        fromView.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.3, animations: {
            fromView.transform = animateDown
            //            toView.transform = animateFloat
            toView.alpha = 1
        }) { (success) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.4, animations: {
                    fromView.backgroundColor = .white
//                })
//            }
        }
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
//            fromView.transform = animateDown
////            toView.transform = animateFloat
//            toView.alpha = 1
//        }) { (success) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            DispatchQueue.main.async {
////                UIView.animate(withDuration: 0.6, animations: {
////                    fromView.backgroundColor = .white
////                })
////            }
////            
//        }
 
    }
    
    func handlePan(pan: UIPanGestureRecognizer) {
        if let interactingView = pan.view {
            
            
//            print("check \(interactingView.frame.origin.y)")
//            print("check \(interactingView.bounds.height)")
//            print("check \(self.sourceViewController.tableView.contentOffset.y)")
            
            var translation = pan.translation(in: interactingView)
//            let d = translation.y / interactingView.bounds.height * 0.4
            if self.transitionStarted && translation.y == 0 {
                translation = self.tempTranslation
            }
            let d = (translation.y) / interactingView.bounds.height
            
            guard let interactingView = pan.view else { return }
//            print("translation-=================== \(translation.y)")
            if !self.transitionStarted {
                if !self.scrolledToTop {
                    return
                }
            }
            
            switch pan.state {
            case .began:
//                print("check translation: \( pan.velocity(in: interactingView).y)")
//                if pan.velocity(in: interactingView).y > 0 {
                if translation.y >= 0 {
//                    print("check SSSSSTTTTAAAARRRRRRTTTT-----")
                    self.tempTranslation = translation
                    self.preparedToTrack = true
//                    guard let identifier = self.parentVC else { return }
//                    self.sourceViewController.performSegue(withIdentifier: identifier, sender: nil)
//                    self.transitionStarted = true
//                    self.sourceViewController.tableView.backgroundColor = .clear
                }
            case .changed:
                if self.preparedToTrack {
                    if pan.velocity(in: interactingView).y > 0 {
                        guard let identifier = self.parentVC else { return }
                        print("identifier ------- \(identifier)")
                        self.preparedToTrack = false
                        self.sourceViewController.performSegue(withIdentifier: identifier, sender: nil)
                        self.transitionStarted = true
                        self.sourceViewController.tableView.backgroundColor = .clear
                    }
                }
//                pan.location(ofTouch: <#T##Int#>, in: <#T##UIView?#>)
//                print("-------- \(pan.velocity(in: interactingView).y)")
                print("check translation: \(translation.y)")
//                print("check translation: \(d)")
                if self.transitionStarted {
                    if d < 0 {
//                        self.cancel()
                        
                    } else {
//                        self.update(d/2)
                        self.update(d)
                    }
                }
            case .cancelled:
                self.preparedToTrack = false
                break
            case .ended:
                print("ended")
//                if pan.velocity(in: interactingView).y > 0 {
//                if pan.velocity(in: interactingView).y > 0 || translation.y > 100 {
//                print("-------- \(pan.velocity(in: interactingView).y)")
                if translation.y > 200 || pan.velocity(in: interactingView).y > 1500 {
                    if self.transitionStarted {
                        print("check FIIIINIIIIIISSSSHHHHHH")
                        self.finish()
                    }
                } else {
                    if self.transitionStarted {
                        print("check CANCEL")
                        self.cancel()
                    }
                }
                self.transitionStarted = false
                self.preparedToTrack = false
                break
            default:
                self.finish()
                self.transitionStarted = false
                self.preparedToTrack = false
                break
            }
        }
    }
}
