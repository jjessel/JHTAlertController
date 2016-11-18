//
//  JHTAlertAction.swift
//  JHTAlertController
//
//  Created by Jessel, Jeremiah on 11/15/16.
//  Copyright © 2016 Jacuzzi Hot Tubs, LLC. All rights reserved.
//

import UIKit

public class JHTAlertAction: NSObject, NSCopying {
   
   var title: String
   var style: JHTAlertActionStyle
   var handler: ((JHTAlertAction) -> Void)!
   var bgColor: UIColor?
   var isEnabled = true
   
   required public init(title: String, style: JHTAlertActionStyle, bgColor: UIColor? = nil, handler: ((JHTAlertAction) -> Void)!) {
      self.title = title
      self.style = style
      self.bgColor = bgColor
      self.handler = handler
   }
   
   public func copy(with zone: NSZone? = nil) -> Any {
      let copy = type(of: self).init(title: title, style: style, bgColor: bgColor, handler: handler)
      copy.isEnabled = self.isEnabled
      return copy
   }
   
}
