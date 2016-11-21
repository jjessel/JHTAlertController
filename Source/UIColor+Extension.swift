//
//  UIColor+Extension.swift
//  JHTAlertController
//
//  Created by Jessel, Jeremiah on 11/16/16.
//  Copyright © 2016 Jacuzzi Hot Tubs, LLC. All rights reserved.
//

import UIKit


public extension UIColor {
   
   // MARK: Appearances
   
   /// A lighter representation of the color
   ///
   /// - Returns: the lighter color
   public func lightColor() -> UIColor {
      return self.withAlphaComponent(0.5)
   }
   
   /// A darker representation of the color
   ///
   /// - Returns: the darker color
   public func darker() -> UIColor {
      
      var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
      
      if self.getRed(&r, green: &g, blue: &b, alpha: &a){
         return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
      }
      
      return UIColor()
   }
   
   /// Creates an image with a specified color
   ///
   /// - Parameters:
   ///   - color: the color to create an image from
   ///   - size: the size of the image
   /// - Returns: the image with the color specified
   class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 60, height: 60)) -> UIImage {
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      UIGraphicsBeginImageContext(rect.size)
      let context = UIGraphicsGetCurrentContext()
      
      context!.setFillColor(color.cgColor);
      context!.fill(rect);
      
      let image = UIGraphicsGetImageFromCurrentImageContext()!
      
      UIGraphicsEndImageContext();
      
      return image;
   }
   
   /// Creates an image with a specified color
   ///
   /// - Parameter size: the size of the image
   /// - Returns: the image with the color specified
   public func imageWithColor(size: CGSize = CGSize(width: 60, height: 60)) -> UIImage {
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      UIGraphicsBeginImageContext(rect.size)
      let context = UIGraphicsGetCurrentContext()
      
      context!.setFillColor(self.cgColor);
      context!.fill(rect);
      
      let image = UIGraphicsGetImageFromCurrentImageContext()!
      
      UIGraphicsEndImageContext();
      
      return image;
   }
}
