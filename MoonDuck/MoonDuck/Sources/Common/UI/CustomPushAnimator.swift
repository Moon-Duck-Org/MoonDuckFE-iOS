//
//  CustomPushAnimator.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        // Start the toViewController below the screen
        toViewController.view.frame = finalFrame.offsetBy(dx: 0, dy: containerView.bounds.height)
        containerView.addSubview(toViewController.view)
        
        // Animate toViewController to its final position
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}
