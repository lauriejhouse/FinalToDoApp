//
//  CustomNavigationAnimator.swift
//  
//
//  Created by Jackie Norstrom on 1/25/19.
//

import UIKit

class CustomNavigationAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        
        let toViewControllerEndFrame = transitionContext.finalFrame(for: toViewController)
        var toViewControllerStartFrame = toViewControllerEndFrame
        toViewControllerStartFrame.origin.y -= UIScreen.main.bounds.height
        toViewController.view.frame = toViewControllerStartFrame
        transitionContext.containerView.addSubview(toViewController.view)
        
        let snapshotView = toViewController.view.snapshotView(afterScreenUpdates: true)
        snapshotView?.frame = (fromViewController.view.frame).insetBy(dx: fromViewController.view.frame.size.width / 2, dy: fromViewController.view.frame.size.height / 2)
        transitionContext.containerView.addSubview(snapshotView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshotView?.frame = toViewControllerEndFrame
        }, completion: {
            finished in
            toViewController.view.frame = toViewControllerEndFrame
            snapshotView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
