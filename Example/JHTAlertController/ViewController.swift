//
//  ViewController.swift
//  JHTAlertController
//
//  Created by placeholder for master on 11/17/2016.
//  Copyright (c) 2016 placeholder for master. All rights reserved.
//

import UIKit
import JHTAlertController

class ViewController: UIViewController {
   let defaultBgColor = UIColor(red:0.82, green:0.93, blue:0.99, alpha:1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = defaultBgColor
    }
   @IBAction func darkAlert(_ sender: Any) {
      let alertController = JHTAlertController(title: "", message: "This is an alert. It is only an alert.", preferredStyle: .alert)
      alertController.titleImage = #imageLiteral(resourceName: "Turtle")
      alertController.titleViewBackgroundColor = .black
      alertController.alertBackgroundColor = .black
      alertController.setAllButtonBackgroundColors(to: .black)
      alertController.hasRoundedCorners = true
      
      // Create the action.
      let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)
      let okAction = JHTAlertAction(title: "Yes", style: .default) { _ in
         print("Do something here!")
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(okAction)
      
      // Show alert
      present(alertController, animated: true, completion: nil)
   }
   @IBAction func lightAlert(_ sender: Any) {
      let alertController = JHTAlertController(title: "", message: "This message is a placeholder so you can see what the alert looks like with a message.", preferredStyle: .alert)
      alertController.titleImage = #imageLiteral(resourceName: "Turtle")
      alertController.titleViewBackgroundColor = .black
      alertController.alertBackgroundColor = .lightGray
      alertController.setAllButtonBackgroundColors(to: .lightGray)
      
      alertController.hasRoundedCorners = true
      
      let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)
      let okAction = JHTAlertAction(title: "Yes", style: .default) { _ in
         print("Do something here!")
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(okAction)
      
      present(alertController, animated: true, completion: nil)
   }
   @IBAction func threeButtonAlert(_ sender: Any) {
      let alertController = JHTAlertController(title: "Turtle", message: "In this alert we use a String for the title instead of an image.", preferredStyle: .alert)
      alertController.titleViewBackgroundColor = UIColor.white
      alertController.titleTextColor = .black
      alertController.alertBackgroundColor = .black
      alertController.setAllButtonBackgroundColors(to: .black)
      alertController.hasRoundedCorners = true
      // You can add plural action.
      let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)
      
      let defaultAction = JHTAlertAction(title: "Default", style: .default, handler: { [weak self] _ in
         self?.view.backgroundColor = self?.defaultBgColor
      })
      
      let blueAction = JHTAlertAction(title: "Red", style: .default) { [weak self] _ in
         self?.view.backgroundColor = .red
      }
      alertController.addActions([defaultAction,blueAction, cancelAction])
      
      // Show alert
      present(alertController, animated: true, completion: nil)
   }
   @IBAction func iconAlert(_ sender: Any) {
      let alertController = JHTAlertController(title: "Wow!", message: "You can even set an icon for the alert.", preferredStyle: .alert, iconImage: #imageLiteral(resourceName: "TurtleDark") )
      alertController.titleViewBackgroundColor = .white
      alertController.titleTextColor = .black
      alertController.alertBackgroundColor = .white
      alertController.messageFont = .systemFont(ofSize: 18)
      alertController.messageTextColor = .black
      alertController.setAllButtonBackgroundColors(to: .white)
      alertController.setButtonTextColorFor(.default, to: .black)
      alertController.setButtonTextColorFor(.cancel, to: .black)
      alertController.dividerColor = .black
      alertController.hasRoundedCorners = true
      
      // Create the action.
      let cancelAction = JHTAlertAction(title: "Cancel", style: .cancel,  handler: nil)
      let okAction = JHTAlertAction(title: "Yes", style: .default) { _ in
         guard let textField = alertController.textFields?.first else { return }
         print(textField.text!)
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(okAction)
      
      alertController.addTextFieldWithConfigurationHandler { (textField) in
         textField.placeholder = "Some Info Here"
      }
      
      // Show alert
      present(alertController, animated: true, completion: nil)
   }
}
