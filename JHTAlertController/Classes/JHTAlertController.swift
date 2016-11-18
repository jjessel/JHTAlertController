//
//  JHTAlert.swift
//  JHTAlertController
//
//  Created by Jessel, Jeremiah on 11/16/16.
//  Copyright © 2016 Jacuzzi Hot Tubs, LLC. All rights reserved.
//

import UIKit

public enum JHTAlertActionStyle : Int {
   case `default`, cancel, destructive
}

public enum JHTAlertControllerStyle : Int {
   case actionSheet, alert
}

public class JHTAlertController: UIViewController, UIViewControllerTransitioningDelegate {
   
   private(set) var preferredStyle: JHTAlertControllerStyle!
   var isAlert: Bool { return preferredStyle == .alert }
   
   private var shapeLayer = CAShapeLayer()
   
   // ContainerView for all Alert Components
   private var containerView = UIView()
   private var containerViewWidth: CGFloat = 270.0
   public var cornerRadius: CGFloat = 15.0 {
      didSet {
         containerView.layer.cornerRadius = self.cornerRadius
      }
   }
   public var hasRoundedCorners = true {
      didSet {
         if hasRoundedCorners {
            containerView.layer.cornerRadius = self.cornerRadius
         } else {
            containerView.layer.cornerRadius = 0.0
         }
      }
   }
   public var alertBackgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0) {
      didSet {
         containerView.backgroundColor = alertBackgroundColor
      }
   }
   
   // TitleSection
   private var titleView = UIView()
   private let titleViewHeight: CGFloat = 45.0
   public var titleViewBackgroundColor = UIColor.black {
      didSet {
         titleView.backgroundColor = titleViewBackgroundColor
         shapeLayer.fillColor = titleViewBackgroundColor.cgColor
      }
   }
   private var titleLabel = UILabel()
   public var titleFont = UIFont(name: "Avenir-Roman", size: 22) {
      didSet {
         titleLabel.font = titleFont
      }
   }
   public var titleTextColor = UIColor.white {
      didSet {
         titleLabel.textColor = titleTextColor
      }
   }
   
   public var titleImage: UIImage? {
      didSet {
         updateTitleImage()
      }
   }
   
   // MessageView
   private var messageView = UIView()
   private var messageLabel = UILabel()
   public var messageFont = UIFont(name: "Avenir-Roman", size: 16) {
      didSet {
         messageLabel.font = messageFont
      }
   }
   public var messageTextColor = UIColor.white {
      didSet {
         messageLabel.textColor = messageTextColor
      }
   }
   private var message: String!
   
   // ButtonContainer
   private var buttonContainerView = UIStackView()
   
   private var buttonActions: [JHTAlertAction] = []
   private var defaultButton = UIButton()
   public var dividerColor = UIColor.white
   private var borderWidth: CGFloat = 0.5
   
   // Button configurations
   private var buttons = [UIButton]()
   private var cancelButtonTag = 0
   private var buttonFont: [JHTAlertActionStyle : UIFont] = [
      .default : UIFont(name: "Avenir-Roman", size: 18)!,
      .cancel  : UIFont(name: "Avenir-Black", size: 18)!,
      .destructive  : UIFont(name: "Avenir-Roman", size: 18)!
   ]
   private var buttonTextColor: [JHTAlertActionStyle : UIColor] = [
      .default : UIColor.white,
      .cancel  : UIColor.white,
      .destructive  : UIColor.red
   ]
   
   private var buttonBackgroundColor: [JHTAlertActionStyle : UIColor] = [
      .default : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0),
      .cancel  : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0),
      .destructive  : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
   ]
   
   
   required convenience public init(title: String, message: String, preferredStyle: JHTAlertControllerStyle, iconImage: UIImage? = nil) {
      self.init(nibName: nil, bundle: nil)

      self.title = title
      self.message = message
      self.preferredStyle = preferredStyle

      self.providesPresentationContextTransitionStyle = true
      self.definesPresentationContext = true
      self.modalPresentationStyle = UIModalPresentationStyle.custom
      self.transitioningDelegate = self
      
      
      // Setup ContainerView
      containerView.frame.size = CGSize(width: containerViewWidth, height:300)
      containerView.backgroundColor = alertBackgroundColor
      containerView.translatesAutoresizingMaskIntoConstraints = false
      containerView.layer.cornerRadius = cornerRadius
      containerView.clipsToBounds = true
      view.addSubview(containerView)
      
      let containerViewCenterXConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
      let containerViewCenterYConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
      let containerViewHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
      let containterViewWidthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: containerViewWidth)
      view.addConstraints([containerViewCenterXConstraint,
                           containerViewCenterYConstraint,
                           containterViewWidthConstraint,
                           containerViewHeightConstraint])
      
      // Setup Image Circle
      if iconImage != nil {
         
         let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.maxX / 2,y: containerView.center.y * 1.65), radius: CGFloat(40), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
         
         shapeLayer = CAShapeLayer()
         shapeLayer.path = circlePath.cgPath
         
         //change the fill color
         shapeLayer.fillColor = titleViewBackgroundColor.cgColor
         view.layer.insertSublayer(shapeLayer, below: containerView.layer)
         let imageView = UIImageView(image: iconImage)
         view.addSubview(imageView)
         imageView.translatesAutoresizingMaskIntoConstraints = false
         let centerX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
         let centerY = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 5)

         view.addConstraints([centerX, centerY])
         
      }
      
      // Setup TitleView
      titleView.frame.size = CGSize(width: containerViewWidth, height: titleViewHeight)
      titleView.backgroundColor = titleViewBackgroundColor
      titleView.translatesAutoresizingMaskIntoConstraints = false
      titleView.clipsToBounds = true
      containerView.addSubview(titleView)
      
      let titleViewLeadingConstraint = NSLayoutConstraint(item: titleView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
      let titleViewTrailingConstraint = NSLayoutConstraint(item: titleView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
      let titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleViewHeight)
      let titleViewTopConstriant = NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0.0)
      
      view.addConstraints([titleViewLeadingConstraint,
                           titleViewTopConstriant,
                           titleViewTrailingConstraint,
                           titleViewHeightConstraint])
      
      // Setup TitleLabel
      titleLabel.frame.size = titleView.frame.size
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.textColor = titleTextColor
      titleLabel.font = titleFont
      titleLabel.text = title
      titleLabel.textAlignment = .center
      titleView.addSubview(titleLabel)
      
      let titleLabelLeadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: titleView, attribute: .leading, multiplier: 1.0, constant: 0.0)
      let titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: titleView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
      let titleLabelBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
      let titleLabelTopConstriant = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .top, multiplier: 1.0, constant: 0.0)
      view.addConstraints([titleLabelLeadingConstraint,
                           titleLabelTopConstriant,
                           titleLabelTrailingConstraint,
                           titleLabelBottomConstraint])
      
      // Setup MessageView
      messageView.frame.size = CGSize(width: containerViewWidth, height: titleViewHeight)
      messageView.translatesAutoresizingMaskIntoConstraints = false
      messageView.clipsToBounds = true
      containerView.addSubview(messageView)
      let messageViewLeadingConstraint = NSLayoutConstraint(item: messageView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
      let messageViewTrailingConstraint = NSLayoutConstraint(item: messageView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
      let messageViewBottomConstraint = NSLayoutConstraint(item: messageView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
      let messageViewTopConstriant = NSLayoutConstraint(item: messageView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
      view.addConstraints([messageViewLeadingConstraint,
                           messageViewTopConstriant,
                           messageViewTrailingConstraint,
                           messageViewBottomConstraint])
      
      // Setup MessageLabel
      messageLabel.frame.size = CGSize(width:containerViewWidth - 20, height:0.0)
      messageLabel.translatesAutoresizingMaskIntoConstraints = false
      messageLabel.numberOfLines = 0
      messageLabel.minimumScaleFactor = 0.5
      messageLabel.textAlignment = .center
      messageLabel.font = messageFont
      messageLabel.textColor = messageTextColor
      messageLabel.text = message
      messageView.addSubview(messageLabel)
      
      let messageLabelLeadingConstraint = NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: messageView, attribute: .leading, multiplier: 1.0, constant: 10.0)
      let messageLabelTrailingConstraint = NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: messageView, attribute: .trailing, multiplier: 1.0, constant:-10.0)
      let messageLabelBottomConstraint = NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: messageView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
      let messageLabelTopConstriant = NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: messageView, attribute: .top, multiplier: 1.0, constant: 0.0)
      view.addConstraints([messageLabelLeadingConstraint,
                           messageLabelTopConstriant,
                           messageLabelTrailingConstraint,
                           messageLabelBottomConstraint])
      
   }
   
   override public func viewWillAppear(_ animated: Bool) {
      
      // Setup ButtonContainerView
      buttonContainerView.frame.size = CGSize(width: containerViewWidth, height: 240.0)
      buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
      buttonContainerView.clipsToBounds = true
      buttonContainerView.distribution = .fillEqually
      buttonContainerView.alignment = .fill
      buttonContainerView.axis = (buttonContainerView.arrangedSubviews.count > 2) ? .vertical : .horizontal
      
      containerView.addSubview(buttonContainerView)
      
      let buttonContainerViewLeadingConstraint = NSLayoutConstraint(item: buttonContainerView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
      let buttonContainerViewTrailingConstraint = NSLayoutConstraint(item: buttonContainerView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
      let buttonContainerHeight = (buttonContainerView.arrangedSubviews.count > 2) ? titleViewHeight * CGFloat(buttons.count) : titleViewHeight
      let buttonContainerViewHeightConstraint = NSLayoutConstraint(item: buttonContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonContainerHeight)
      let buttonContainerViewTopConstriant = NSLayoutConstraint(item: buttonContainerView, attribute: .top, relatedBy: .equal, toItem: messageView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
      let buttonContainerViewBottomConstraint = NSLayoutConstraint(item: buttonContainerView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0)
      
      view.addConstraints([buttonContainerViewLeadingConstraint,
                           buttonContainerViewTopConstriant,
                           buttonContainerViewTrailingConstraint,
                           buttonContainerViewHeightConstraint,
                           buttonContainerViewBottomConstraint])
      
      if buttonContainerView.arrangedSubviews.count  == 2 {
         let btn = buttonContainerView.arrangedSubviews.last as! UIButton
         let border = CALayer()
         border.borderWidth = borderWidth
         border.borderColor = dividerColor.cgColor
         border.frame = CGRect(x: 0, y: 0, width: btn.frame.size.width + 2, height: btn.frame.size.height + 2)
         btn.layer.addSublayer(border)
      }
   }
   
   // Update the title image if it was added after initialization
   private func updateTitleImage() {
      guard titleImage != nil else { return }
      let imageView = UIImageView()
      imageView.frame = titleView.frame
      imageView.contentMode = .scaleAspectFit
      imageView.image = titleImage
      titleView.addSubview(imageView)
      
      imageView.translatesAutoresizingMaskIntoConstraints = false
      let trailing = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: titleView, attribute: .trailing, multiplier: 1.0, constant: 0)
      let leading = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: titleView, attribute: .leading, multiplier: 1.0, constant: 0)
      let top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .top, multiplier: 1.0, constant: 8)
      let bottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1.0, constant: -8)
      
      view.addConstraints([trailing, leading, top, bottom])
   }

   // MARK: Public Methods
   
   // Adds an action to be presented in the alert.
   public func addAction(_ action: JHTAlertAction) {
      
      // Add action to list
      buttonActions.append(action)
      
      // Create button
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: containerViewWidth, height: titleViewHeight))
      button.setTitle(action.title, for: .normal)
      button.titleLabel?.font = buttonFont[action.style]
      button.setTitleColor(buttonTextColor[action.style], for: .normal)
      button.isEnabled = action.isEnabled
      button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
      let bgColor = (action.bgColor != nil) ? action.bgColor! : buttonBackgroundColor[action.style]!
      button.backgroundColor = bgColor
      button.setBackgroundImage(UIColor.imageWithColor(bgColor.darker(), size: button.frame.size), for: .highlighted)
      button.tag = buttons.count + 1
      button.clipsToBounds = true
      
      // Setup border for separation
      let border = CALayer()
      border.borderWidth = borderWidth
      border.borderColor = dividerColor.cgColor
      border.frame = CGRect(x: -1, y: 0, width: button.frame.size.width + 2, height: button.frame.size.height + 2)
      button.layer.addSublayer(border)
      
      // Add button to list and stackview
      buttons.append(button)
      buttonContainerView.addArrangedSubview(button)
   }
   
   // Convenience to add multiple actions
   public func addActions(_ actions: [JHTAlertAction]) {
      for action in actions {
         addAction(action)
      }
   }
   
   // Handle the button action press
   public func buttonTapped(sender: UIButton) {
      sender.isSelected = true
      let action = buttonActions[sender.tag - 1]
      if action.handler != nil {
         action.handler(action)
      }
      self.dismiss(animated: true, completion: nil)
   }
   
   // Set the font for a specific action style
   public func setButtonFontFor(_ action: JHTAlertActionStyle, to font: UIFont) {
      buttonFont[action] = font
   }
   
   public func setButtonTextColorFor(_ action: JHTAlertActionStyle, to color: UIColor) {
      buttonTextColor[action] = color
   }
   
   public func setButtonBackgroundColorFor( _ action: JHTAlertActionStyle, to color: UIColor) {
      buttonBackgroundColor[action] = color
   }
   
   public func setAllButtonBackgroundColors(to color: UIColor) {
      buttonBackgroundColor[JHTAlertActionStyle.default] = color
      buttonBackgroundColor[JHTAlertActionStyle.destructive] = color
      buttonBackgroundColor[JHTAlertActionStyle.cancel] = color
   }
   
   // MARK: UIViewControllerTransitioningDelegate Methods
   public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return JHTAlertAnimation(isPresenting: true)
   }
   
   public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return JHTAlertAnimation(isPresenting: false)
   }
}





