//
//  DismissAnimator.swift
//  Scribe
//
//  Created by Mikael Son on 7/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class DismissAnimator : NSObject {
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            
            else {
                return
        }
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
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    // Shift the snapshot down by one screen length
                    snapshot.center.y += UIScreen.main.bounds.height
            },
                completion: { _ in
                    // Cleanup.
                    // Undo the hidden state. User won't see this because transition is already over.
                    fromVC.view.isHidden = false
                    // It's already off-screen, but get rid of the snapshot anyway.
                    snapshot.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            )
        }
        
    }
}


class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
