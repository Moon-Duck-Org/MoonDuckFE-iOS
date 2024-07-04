//
//  CustomPopAnimator.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let initialFrame = transitionContext.initialFrame(for: fromViewController)
        
        // Start the fromViewController at its initial position
        fromViewController.view.frame = initialFrame
        containerView.addSubview(fromViewController.view)
        
        // Animate fromViewController out of the screen
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = initialFrame.offsetBy(dx: 0, dy: containerView.bounds.height)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
