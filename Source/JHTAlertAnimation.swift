//
//  JHTAlertAnimation.swift
//  JHTAlertController
//
//  Created by Jessel, Jeremiah on 11/15/16.
//  Copyright © 2016 Jacuzzi Hot Tubs, LLC. All rights reserved.
//

import UIKit

public class JHTAlertAnimation : NSObject, UIViewControllerAnimatedTransitioning {
   
   /// Lets the animation transition know if the alert is presenting or dismissing
   let isPresenting: Bool
   
   
   /// The initialization of the JHTAlertAnimation
   ///
   /// - Parameter isPresenting: a Bool that determines if the alert is presenting or dismissing
   init(isPresenting: Bool) {
      self.isPresenting = isPresenting
   }
   
   // MARK: Transition Animations
   
   /// The duration of the animation.
   ///
   /// - Parameter transitionContext: the context of the animation
   /// - Returns: a time interval that differes if the alert is presenting or dismissing
   public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return isPresenting ? 0.2 : 0.2
   }
   
   /// Calls the appropriate animatation
   ///
   /// - Parameter transitionContext: the context of the animation
   public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      if isPresenting {
         self.presentAnimateTransition(transitionContext)
      } else {
         self.dismissAnimateTransition(transitionContext)
      }
   }
   
   /// Presents the alert animation
   ///
   /// - Parameter transitionContext: the context for the animation
   func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
      
      guard let alertController = transitionContext.viewController(forKey: .to) as? JHTAlertController else {
         return
      }
      
      let containerView = transitionContext.containerView
      containerView.addSubview(alertController.view)
      containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
      containerView.alpha = 0
      
      alertController.view.alpha = 0.0
      alertController.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      
      UIView.animate(withDuration:self.transitionDuration(using: transitionContext), animations: {
         alertController.view.alpha = 1.0
         containerView.alpha = 1.0
         alertController.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
      }, completion: { _ in
         UIView.animate(withDuration: 0.2, animations: {
            alertController.view.transform = CGAffineTransform.identity
         }, completion: { _ in
            
            transitionContext.completeTransition(true)
            
         })
      })
   }
   
   /// The dismiss animation for the alert
   ///
   /// - Parameter transitionContext: the context for the animation
   func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
      let alertController = transitionContext.viewController(forKey: .from) as! JHTAlertController
      let containerView = transitionContext.containerView
      
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
         alertController.view.alpha = 0.0
         containerView.alpha = 0.0
      }, completion: { _ in
         transitionContext.completeTransition(true)
      })
      
   }
   
   
}
