//
//  JHTAlert.swift
//  JHTAlertController
//
//  Created by Jessel, Jeremiah on 11/16/16.
//  Copyright © 2016 Jacuzzi Hot Tubs, LLC. All rights reserved.
//

import UIKit

/// Used to represent the style of the alert action
///
/// - default: will display with standard font choice
///
/// - cancel: will display with a bold style font
///
/// - destructive: will display with red text color to indicate a destructive behavior
public enum JHTAlertActionStyle : Int {
   /// will display with standard font choice
   case `default`
   /// will display with a bold style font
   case cancel
   /// will display with red text color to indicate a destructive behavior
   case destructive
}

/// Used to represent the style of the alert
///
/// - actionSheet: an alert that slides from the bottom
///
/// - alert: an alert that is diplayed in the center of the view
public enum JHTAlertControllerStyle : Int {
   /// an alert that slides from the bottom
   case actionSheet
   ///  an alert that is diplayed in the center of the view
   case alert
}

/// The class for configuring and creating customizable alerts. See https://github.com/jjessel/JHTAlertController for more information.
public class JHTAlertController: UIViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate {
   // MARK: Configuring the Alert
   private(set) var preferredStyle: JHTAlertControllerStyle!
   
   /// Is the alert style of .alert
   var isAlert: Bool { return preferredStyle == .alert }
   
   private var shapeLayer = CAShapeLayer()
   private var iconBackgroundRadius: CGFloat = 45.0
   
   // MARK:  ContainerView for all Alert Components
   private var containerView = UIView()
   private var containerViewWidth: CGFloat = 270.0
   
   /// The corner radius for the alert
   public var cornerRadius: CGFloat = 15.0 {
      didSet {
         containerView.layer.cornerRadius = self.cornerRadius
      }
   }
   
   /// Defines whether the alert has rounded corners
   public var hasRoundedCorners = true {
      didSet {
         if hasRoundedCorners {
            containerView.layer.cornerRadius = self.cornerRadius
         } else {
            containerView.layer.cornerRadius = 0.0
         }
      }
   }
   
   /// The background color for the message area of the alert
   public var alertBackgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0) {
      didSet {
         containerView.backgroundColor = alertBackgroundColor
      }
   }
   
   // MARK:  TitleSection
   private var titleView = UIView()
   private let titleViewHeight: CGFloat = 45.0
   
   /// The background color for the title block
   public var titleViewBackgroundColor = UIColor.black {
      didSet {
         titleView.backgroundColor = titleViewBackgroundColor
         shapeLayer.fillColor = titleViewBackgroundColor.cgColor
      }
   }
   private var titleLabel = UILabel()
   
   /// The font to be used for the title block
   public var titleFont = UIFont(name: "Avenir-Roman", size: 22) {
      didSet {
         titleLabel.font = titleFont
      }
   }
   
   /// The number of the lines to be used for the title block
   public var titleNumberOfLines = 0 {
      didSet {
         titleLabel.numberOfLines = titleNumberOfLines
      }
    }
   
   /// Restrict the height of the title block to the same as the button height
   public var restrictTitleViewHeight = false {
      didSet {
         addTitleHeightConstraint()
      }
   }
   
   /// The text color for the title block
   public var titleTextColor = UIColor.white {
      didSet {
         titleLabel.textColor = titleTextColor
      }
   }
   
   /// The image to be used in the title block
   public var titleImage: UIImage? {
      didSet {
         updateTitleImage()
      }
   }
  
   private var iconImageView: UIImageView?
  
   // MARK:  MessageView
   private var messageView = UIView()
   private var messageLabel = UILabel()
   /// The font for the alert message
   public var messageFont = UIFont(name: "Avenir-Roman", size: 16) {
      didSet {
         messageLabel.font = messageFont
      }
   }
   /// The text color for the alert message
   public var messageTextColor = UIColor.white {
      didSet {
         messageLabel.textColor = messageTextColor
      }
   }
   private var message: String!
   
   // MARK:  ButtonContainer
   private var buttonContainerView = UIStackView()
   
   private var buttonActions: [JHTAlertAction] = []
   private var defaultButton = UIButton()
   /// The separator color between the actions and the message
   public var dividerColor = UIColor.white
   private var borderWidth: CGFloat = 0.5
   
   // Button configurations
   private var buttons = [UIButton]()
   private var cancelButtonTag = 0
   
   /// The default fonts for actions
   ///
   /// - default: Avenir-Roman, 18
   /// 
   /// - cancel: Avenir-Black, 18
   ///
   /// - destructive: Avenir-Roman, 18
   private(set) var buttonFont: [JHTAlertActionStyle : UIFont] = [
      .default : UIFont(name: "Avenir-Roman", size: 18)!,
      .cancel  : UIFont(name: "Avenir-Black", size: 18)!,
      .destructive  : UIFont(name: "Avenir-Roman", size: 18)!
   ]
   
   /// The default text colors for actions
   ///
   /// - default: white
   ///
   /// - cancel: white
   ///
   /// - destructive: red
   private(set) var buttonTextColor: [JHTAlertActionStyle : UIColor] = [
      .default : UIColor.white,
      .cancel  : UIColor.white,
      .destructive  : UIColor.red
   ]
   
   /// The default background colors for the actions
   ///
   /// - default: grey
   ///
   /// - cancel: grey
   ///
   /// - destructive: grey
   private(set) var buttonBackgroundColor: [JHTAlertActionStyle : UIColor] = [
      .default : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0),
      .cancel  : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0),
      .destructive  : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
   ]
   /// the number of actions added to the alert
   public var actionCount: Int {
      return buttonContainerView.arrangedSubviews.count
   }
   
   // MARK:  Textfield
   private let textFieldHeight: CGFloat = 30.0
   /// The textfields that have been added to the alert
   public private(set) var textFields: [JHTTextField]?
   /// The background color of the text field. The default color is white.
   var textFieldBackgroundColor = UIColor.white
   /// The color of the border outline for the text field. The default color is gray.
   var textFieldBorderColor = UIColor.gray
   /// The type of border around the text field. Default is none
   var textFieldBorderStyle = UITextBorderStyle.none
   private var textFieldContainerView = UIStackView()
   /// An override for the textfield to have rounded corners
   public var textFieldHasRoundedCorners = true
   private let textFieldCornerRadius: CGFloat = 4.0
   
   // MARK:- Initialization and Setup
   
   /// Initialize the JHTAlertController
   ///
   /// - Parameters:
   ///   - title: the title to be displayed on the alert. If there is a title image added later, the title text will not be visible.
   ///   - message: the message to be displayed in the alert
   ///   - preferredStyle: the style of the alert
   ///   - iconImage: an icon image to be added. If there is no icon image specified, the alert will appear like the stock alert. If there is one specified, a round area will display at the top of the alert.
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
         iconImageView = UIImageView(image: iconImage)
         view.addSubview(iconImageView!)
         iconImageView!.translatesAutoresizingMaskIntoConstraints = false

         let imageCenterX = NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
         let imageCenterY = NSLayoutConstraint(item: iconImageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 5)
         view.addConstraints([imageCenterX,
                              imageCenterY])
      }
      
      // Setup TitleView
      titleView.frame.size = CGSize(width: containerViewWidth, height: titleViewHeight)
      titleView.backgroundColor = titleViewBackgroundColor
      titleView.translatesAutoresizingMaskIntoConstraints = false
      titleView.clipsToBounds = true
      containerView.addSubview(titleView)
      
      let titleViewLeadingConstraint = NSLayoutConstraint(item: titleView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
      let titleViewTrailingConstraint = NSLayoutConstraint(item: titleView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
      let titleViewTopConstriant = NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0.0)
      let titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleViewHeight)
      
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
      titleLabel.numberOfLines = titleNumberOfLines
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
      
      // Setup TextFieldContainerView
      textFieldContainerView.frame.size = CGSize(width: containerViewWidth, height: 240.00)
      textFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
      textFieldContainerView.clipsToBounds = true
      textFieldContainerView.distribution = .fillEqually
      textFieldContainerView.alignment = .fill
      textFieldContainerView.axis = .vertical
      textFieldContainerView.spacing = 4
      
      containerView.addSubview(textFieldContainerView)
      
   }
   
   /// The standard view controller life cycle viewWillAppear
   ///
   /// - Parameter animated: an animated appearance
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
      let buttonContainerViewTopConstriant = NSLayoutConstraint(item: buttonContainerView, attribute: .top, relatedBy: .equal, toItem: textFieldContainerView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
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
      updateIconImage()
      
      // Setup TextFieldContainerView Constraints
      
      let textFieldContainerLeadingConstraint = NSLayoutConstraint(item: textFieldContainerView, attribute: .leading, relatedBy: .equal, toItem: messageView, attribute: .leading, multiplier: 1.0, constant: 10)
      let textFieldContainerTrailingConstraint = NSLayoutConstraint(item: textFieldContainerView, attribute: .trailing, relatedBy: .equal, toItem: messageView, attribute: .trailing, multiplier: 1.0, constant: -10)
      let textFieldContainerTopConstraint = NSLayoutConstraint(item: textFieldContainerView, attribute: .top, relatedBy: .equal, toItem: messageView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
      let textFieldContainerHeight = CGFloat(textFieldContainerView.arrangedSubviews.count) * textFieldHeight
      let textFieldContainerHeightConstraint = NSLayoutConstraint(item: textFieldContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: textFieldContainerHeight)
      
      view.addConstraints([textFieldContainerLeadingConstraint,
                           textFieldContainerTrailingConstraint,
                           textFieldContainerTopConstraint,
                           textFieldContainerHeightConstraint])
      
      
   }
   
   /// Add the title block constraint
   private func addTitleHeightConstraint() {
      if restrictTitleViewHeight {
         let titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: titleViewHeight)
         view.addConstraint(titleViewHeightConstraint)
      }
   }
   
   /// Update the title image if it was added after initialization
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
  
  /// Updates the icon image based on the height of the alert.
   private func updateIconImage() {
      if iconImageView != nil {
         
         let shapeView = UIView(frame: iconImageView!.frame)
         shapeView.clipsToBounds = true
         
         shapeView.translatesAutoresizingMaskIntoConstraints = false
         view.insertSubview(shapeView, belowSubview: containerView)
         let centerXConstraint = NSLayoutConstraint(item: shapeView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
         let centerYConstraint = NSLayoutConstraint(item: shapeView, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1.0, constant: 5)
         let heightConstraint = NSLayoutConstraint(item: shapeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: iconBackgroundRadius * 2.2)
         let widthConstraint = NSLayoutConstraint(item: shapeView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: iconBackgroundRadius * 2.2)
         view.addConstraints([centerXConstraint,
                              centerYConstraint,
                              heightConstraint,
                              widthConstraint])
         
         let circlePath = UIBezierPath(arcCenter: CGPoint(x: shapeView.frame.maxX,y: shapeView.frame.maxY), radius: CGFloat(iconBackgroundRadius), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
         
         shapeLayer = CAShapeLayer()
         shapeLayer.path = circlePath.cgPath
         
         //change the fill color
         shapeLayer.fillColor = titleViewBackgroundColor.cgColor
         
         shapeView.layer.addSublayer(shapeLayer)
      }
   }

   // MARK:- Public Methods
   
   /// Adds an action to be presented in the alert.
   ///
   /// - Parameter action: the action to be added to the alert
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
   
   /// Convenience method to add multiple actions to the alert
   ///
   /// - Parameter actions: an array of JHTAlertAction
   public func addActions(_ actions: [JHTAlertAction]) {
      for action in actions {
         addAction(action)
      }
   }
   
   /// The handler method for the action. This is where the code is executed.
   ///
   /// - Parameter sender: the UIButton that was pressed
   public func buttonTapped(sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
      sender.isSelected = true
      let action = buttonActions[sender.tag - 1]
      if action.handler != nil {
         action.handler(action)
      }
   }
   
   /// Set the font for an individual action style. This method needs to be called before the actions are added to the alert.
   ///
   /// - Parameters:
   ///   - action: the type of action to apply the font to
   ///   - font: the font to be applied
   public func setButtonFontFor(_ action: JHTAlertActionStyle, to font: UIFont) {
      buttonFont[action] = font
   }
   
   /// Set the text color for an individual action style. This method needs to be called before the actions are added to the alert.
   ///
   /// - Parameters:
   ///   - action: the type of action to apply the text color to
   ///   - color: the color to be applied
   public func setButtonTextColorFor(_ action: JHTAlertActionStyle, to color: UIColor) {
      buttonTextColor[action] = color
   }
   
   /// Set the background color for an individual action style. This method needs to be called before the actions are added to the alert.
   ///
   /// - Parameters:
   ///   - action: the type of action to apply the background color to
   ///   - color: the color to be applied
   public func setButtonBackgroundColorFor( _ action: JHTAlertActionStyle, to color: UIColor) {
      buttonBackgroundColor[action] = color
   }
   
   /// An easy way to change all the colors of the actions to one color
   ///
   /// - Parameter color: the color to be applied
   public func setAllButtonBackgroundColors(to color: UIColor) {
      buttonBackgroundColor[JHTAlertActionStyle.default] = color
      buttonBackgroundColor[JHTAlertActionStyle.destructive] = color
      buttonBackgroundColor[JHTAlertActionStyle.cancel] = color
   }
   
   /// Add a text fiel to the alert
   ///
   /// - Parameter configurationHandler: the copletion of the textfield
   public func addTextFieldWithConfigurationHandler(configurationHandler: ((JHTTextField) -> Void)!) {
      var textField = JHTTextField()
      textField.frame.size = CGSize(width: containerViewWidth, height: textFieldHeight)
      textField.borderStyle = textFieldBorderStyle
      textField.delegate = self
      
      if configurationHandler != nil {
         configurationHandler(textField)
      }
      
      if textFields == nil {
         textFields = []
      }
      
      if textFieldHasRoundedCorners {
         textField.layer.cornerRadius = textFieldCornerRadius
         textField.clipsToBounds = true
      }
      
      textFields!.append(textField)
      textFieldContainerView.addArrangedSubview(textField)
   }
   
   /// The textfield will resign the first responder
   ///
   /// - Parameter textField: the textfield that was pressed
   /// - Returns: should return value
   public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   // MARK:- UIViewControllerTransitioningDelegate Methods
   
   /// Asks your delegate for the transition animator object to use when presenting a view controller.
   ///
   /// - Parameters:
   ///   - presented: The view controller object that is about to be presented onscreen.
   ///   - presenting: The view controller that is presenting the view controller in the presented parameter. The object in this parameter could be the root view controller of the window, a parent view controller that is marked as defining the current context, or the last view controller that was presented. This view controller may or may not be the same as the one in the source parameter.
   ///   - source: The view controller whose present(_:animated:completion:) method was called.
   /// - Returns: The animator object to use when presenting the view controller or nil if you do not want to present the view controller using a custom transition. The object you return should be capable of performing a fixed-length animation that is not interactive.
   public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return JHTAlertAnimation(isPresenting: true)
   }
   
   /// Asks your delegate for the transition animator object to use when dismissing a view controller.
   ///
   /// - Parameter dismissed: The view controller object that is about to be dismissed.
   /// - Returns: The animator object to use when dismissing the view controller or nil if you do not want to dismiss the view controller using a custom transition. The object you return should be capable of performing a fixed-length animation that is not interactive.
   public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return JHTAlertAnimation(isPresenting: false)
   }
}
