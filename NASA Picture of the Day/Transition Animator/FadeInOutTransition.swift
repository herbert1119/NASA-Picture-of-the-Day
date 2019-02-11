//
//  FadeInOutTransition.swift
//  NASA Picture of the Day
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import UIKit

class FadeInOutTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var animateElements: [UIView]?
    var isPresenting = true
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        animateElements?.forEach{
            $0.alpha = isPresenting ? 1 : 0
        }
        UIView.animate(withDuration: 0.35, animations: { [weak self] in
            toViewController.view.alpha = 1
            guard let self = self else { return }
            self.animateElements?.forEach{
                $0.alpha = self.isPresenting ? 0 : 1
            }
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
}
