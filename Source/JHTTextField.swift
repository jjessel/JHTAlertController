//
//  JHTTextField.swift
//  Pods
//
//  Created by Jessel, Jeremiah on 11/23/16.
//
//

import UIKit

/// A textfield that provides an inset for the text
public class JHTTextField: UITextField {
   let inset: CGFloat = 10
   
   /// placeholder position
   override public func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: inset , dy: 0)
   }
   
   /// text position
   override public func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: inset , dy: 0)
   }
   
   /// the placeholder rect
   override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: inset, dy: 0)
   }
}
